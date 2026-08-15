package com.eventmanagement.service;

import com.eventmanagement.dto.CreateEventRequest;
import com.eventmanagement.dto.EventResponse;
import com.eventmanagement.dto.UpdateEventRequest;
import com.eventmanagement.entity.Event;
import com.eventmanagement.entity.User;
import com.eventmanagement.exception.ForbiddenException;
import com.eventmanagement.exception.ResourceNotFoundException;
import com.eventmanagement.repository.EventRepository;
import com.eventmanagement.repository.UserRepository;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EventService {

    private final EventRepository eventRepository;
    private final UserRepository userRepository;

    public EventService(EventRepository eventRepository, UserRepository userRepository) {
        this.eventRepository = eventRepository;
        this.userRepository = userRepository;
    }

    /**
     * Create a new event. The organizer is always resolved from the authenticated
     * user's email — the client cannot supply an arbitrary organizerId.
     */
    @Transactional
    public EventResponse createEvent(CreateEventRequest request, String organizerEmail) {
        User organizer = resolveUser(organizerEmail);

        validateDateRange(request.getStartDateTime(), request.getEndDateTime());

        Event event = new Event();
        event.setOrganizer(organizer);
        event.setTitle(request.getTitle());
        event.setDescription(request.getDescription());
        event.setCategory(request.getCategory());
        event.setVenue(request.getVenue());
        event.setAddress(request.getAddress());
        event.setCity(request.getCity());
        event.setStartDateTime(request.getStartDateTime());
        event.setEndDateTime(request.getEndDateTime());
        event.setTicketPrice(request.getTicketPrice());
        event.setCapacity(request.getCapacity());
        // On creation availableTickets == capacity (no bookings exist yet)
        event.setAvailableTickets(request.getCapacity());

        Event saved = eventRepository.save(event);
        return EventResponse.fromEvent(saved);
    }

    /**
     * Get a single event by ID. Accessible to any authenticated user.
     */
    @Transactional(readOnly = true)
    public EventResponse getEventById(Long eventId) {
        Event event = findEventOrThrow(eventId);
        return EventResponse.fromEvent(event);
    }

    /**
     * Get all events that belong to the authenticated organizer.
     */
    @Transactional(readOnly = true)
    public List<EventResponse> getOrganizerEvents(String organizerEmail) {
        User organizer = resolveUser(organizerEmail);
        return eventRepository.findByOrganizer(organizer)
                .stream()
                .map(EventResponse::fromEvent)
                .collect(Collectors.toList());
    }

    /**
     * Update an event. Only the owning organizer may do this.
     * Capacity assumption: since no bookings exist in Phase 2A,
     * availableTickets is adjusted proportionally when capacity changes.
     */
    @Transactional
    public EventResponse updateEvent(Long eventId, UpdateEventRequest request, String organizerEmail) {
        Event event = findEventOrThrow(eventId);
        assertOwnership(event, organizerEmail);

        // Validate date range if either date is being updated
        var newStart = request.getStartDateTime() != null ? request.getStartDateTime() : event.getStartDateTime();
        var newEnd = request.getEndDateTime() != null ? request.getEndDateTime() : event.getEndDateTime();
        validateDateRange(newStart, newEnd);

        if (request.getTitle() != null && !request.getTitle().isBlank()) {
            event.setTitle(request.getTitle());
        }
        if (request.getDescription() != null && !request.getDescription().isBlank()) {
            event.setDescription(request.getDescription());
        }
        if (request.getCategory() != null && !request.getCategory().isBlank()) {
            event.setCategory(request.getCategory());
        }
        if (request.getVenue() != null && !request.getVenue().isBlank()) {
            event.setVenue(request.getVenue());
        }
        if (request.getAddress() != null && !request.getAddress().isBlank()) {
            event.setAddress(request.getAddress());
        }
        if (request.getCity() != null && !request.getCity().isBlank()) {
            event.setCity(request.getCity());
        }
        if (request.getStartDateTime() != null) {
            event.setStartDateTime(request.getStartDateTime());
        }
        if (request.getEndDateTime() != null) {
            event.setEndDateTime(request.getEndDateTime());
        }
        if (request.getTicketPrice() != null) {
            event.setTicketPrice(request.getTicketPrice());
        }
        if (request.getCapacity() != null) {
            // Phase 2A: no bookings exist, so availableTickets == capacity always.
            // Set availableTickets = new capacity to keep the invariant.
            event.setCapacity(request.getCapacity());
            event.setAvailableTickets(request.getCapacity());
        }
        if (request.getStatus() != null) {
            event.setStatus(request.getStatus());
        }

        Event saved = eventRepository.save(event);
        return EventResponse.fromEvent(saved);
    }

    /**
     * Delete an event. Only the owning organizer may do this.
     */
    @Transactional
    public void deleteEvent(Long eventId, String organizerEmail) {
        Event event = findEventOrThrow(eventId);
        assertOwnership(event, organizerEmail);
        eventRepository.delete(event);
    }

    // ── Private helpers ────────────────────────────────────────────────────────

    private Event findEventOrThrow(Long eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
    }

    private User resolveUser(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
    }

    /**
     * Ownership check: compares the event's organizer with the authenticated user.
     * The authenticated email comes from the verified JWT — never from the client body.
     */
    private void assertOwnership(Event event, String authenticatedEmail) {
        if (!event.getOrganizer().getEmail().equals(authenticatedEmail)) {
            throw new ForbiddenException("You do not have permission to modify this event");
        }
    }

    private void validateDateRange(java.time.LocalDateTime start, java.time.LocalDateTime end) {
        if (end != null && start != null && !end.isAfter(start)) {
            throw new IllegalArgumentException("End date/time must be after start date/time");
        }
    }
}
