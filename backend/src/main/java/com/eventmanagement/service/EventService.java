package com.eventmanagement.service;

import com.eventmanagement.dto.CreateEventRequest;
import com.eventmanagement.dto.EventResponse;
import com.eventmanagement.dto.UpdateEventRequest;
import com.eventmanagement.entity.Event;
import com.eventmanagement.entity.EventStatus;
import com.eventmanagement.entity.User;
import com.eventmanagement.exception.ForbiddenException;
import com.eventmanagement.exception.ResourceNotFoundException;
import com.eventmanagement.repository.EventRepository;
import com.eventmanagement.repository.UserRepository;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class EventService {

    private final EventRepository eventRepository;
    private final UserRepository userRepository;
    private final ImageStorageService imageStorageService;

    public EventService(EventRepository eventRepository,
                        UserRepository userRepository,
                        ImageStorageService imageStorageService) {
        this.eventRepository     = eventRepository;
        this.userRepository      = userRepository;
        this.imageStorageService = imageStorageService;
    }

    // ── Create ────────────────────────────────────────────────────────────────

    @Transactional
    public EventResponse createEvent(CreateEventRequest request, String organizerEmail) {
        User organizer = resolveUser(organizerEmail);

        validateSchedule(
                request.getRegistrationStartDateTime(),
                request.getRegistrationEndDateTime(),
                request.getStartDateTime(),
                request.getEndDateTime()
        );

        Event event = new Event();
        event.setOrganizer(organizer);
        event.setTitle(request.getTitle());
        event.setDescription(request.getDescription());
        event.setCategory(request.getCategory());
        event.setVenue(request.getVenue());
        event.setAddress(request.getAddress());
        event.setCity(request.getCity());
        event.setRegistrationStartDateTime(request.getRegistrationStartDateTime());
        event.setRegistrationEndDateTime(request.getRegistrationEndDateTime());
        event.setStartDateTime(request.getStartDateTime());
        event.setEndDateTime(request.getEndDateTime()); // may be null
        event.setTicketPrice(request.getTicketPrice());
        event.setCapacity(request.getCapacity());
        event.setAvailableTickets(request.getCapacity());

        return EventResponse.fromEvent(eventRepository.save(event));
    }

    // ── Read single ───────────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public EventResponse getEventById(Long eventId) {
        return EventResponse.fromEvent(findEventOrThrow(eventId));
    }

    // ── Read organizer list ───────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<EventResponse> getOrganizerEvents(String organizerEmail) {
        User organizer = resolveUser(organizerEmail);
        return eventRepository.findByOrganizer(organizer)
                .stream()
                .map(EventResponse::fromEvent)
                .collect(Collectors.toList());
    }

    // ── Update ────────────────────────────────────────────────────────────────

    @Transactional
    public EventResponse updateEvent(Long eventId, UpdateEventRequest request, String organizerEmail) {
        Event event = findEventOrThrow(eventId);
        assertOwnership(event, organizerEmail);

        // Apply field updates first so we validate the final intended state
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
        if (request.getRegistrationStartDateTime() != null) {
            event.setRegistrationStartDateTime(request.getRegistrationStartDateTime());
        }
        if (request.getRegistrationEndDateTime() != null) {
            event.setRegistrationEndDateTime(request.getRegistrationEndDateTime());
        }
        if (request.getStartDateTime() != null) {
            event.setStartDateTime(request.getStartDateTime());
        }

        // endDateTime: three cases
        //   removeEndDateTime=true  → clear to null
        //   endDateTime != null     → set new value
        //   otherwise               → leave unchanged
        if (request.isRemoveEndDateTime()) {
            event.setEndDateTime(null);
        } else if (request.getEndDateTime() != null) {
            event.setEndDateTime(request.getEndDateTime());
        }

        if (request.getTicketPrice() != null) {
            event.setTicketPrice(request.getTicketPrice());
        }
        if (request.getCapacity() != null) {
            event.setCapacity(request.getCapacity());
            event.setAvailableTickets(request.getCapacity());
        }
        if (request.getStatus() != null) {
            event.setStatus(request.getStatus());
        }

        // Validate the resulting schedule
        validateSchedule(
                event.getRegistrationStartDateTime(),
                event.getRegistrationEndDateTime(),
                event.getStartDateTime(),
                event.getEndDateTime()
        );

        return EventResponse.fromEvent(eventRepository.save(event));
    }

    // ── Delete ────────────────────────────────────────────────────────────────

    @Transactional
    public void deleteEvent(Long eventId, String organizerEmail) {
        Event event = findEventOrThrow(eventId);
        assertOwnership(event, organizerEmail);
        imageStorageService.delete(event.getImageUrl());
        eventRepository.delete(event);
    }

    // ── Image upload ──────────────────────────────────────────────────────────

    @Transactional
    public EventResponse uploadImage(Long eventId, MultipartFile file, String organizerEmail)
            throws IOException {
        Event event = findEventOrThrow(eventId);
        assertOwnership(event, organizerEmail);

        String newImageUrl = imageStorageService.store(file);
        imageStorageService.delete(event.getImageUrl());
        event.setImageUrl(newImageUrl);
        return EventResponse.fromEvent(eventRepository.save(event));
    }

    // ── Image remove ──────────────────────────────────────────────────────────

    @Transactional
    public EventResponse removeImage(Long eventId, String organizerEmail) {
        Event event = findEventOrThrow(eventId);
        assertOwnership(event, organizerEmail);
        imageStorageService.delete(event.getImageUrl());
        event.setImageUrl(null);
        return EventResponse.fromEvent(eventRepository.save(event));
    }

    // ── Attendee discovery ────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<EventResponse> discoverEvents(
            String keyword, String category,
            LocalDateTime startDate, LocalDateTime endDate) {

        String kw  = (keyword  != null && keyword.isBlank())  ? null : keyword;
        String cat = (category != null && category.isBlank()) ? null : category;

        return eventRepository
                .findDiscoverableEvents(EventStatus.PUBLISHED, kw, cat, startDate, endDate)
                .stream()
                .map(EventResponse::fromEvent)
                .collect(Collectors.toList());
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Event findEventOrThrow(Long eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
    }

    private User resolveUser(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
    }

    private void assertOwnership(Event event, String authenticatedEmail) {
        if (!event.getOrganizer().getEmail().equals(authenticatedEmail)) {
            throw new ForbiddenException("You do not have permission to modify this event");
        }
    }

    /**
     * Validates the four-field schedule:
     *
     *   1. registrationStart < registrationEnd
     *   2. registrationEnd  <= eventStart
     *   3. if eventEnd != null: eventStart < eventEnd
     *
     * All four fields that participate in a rule must be non-null for that
     * rule to fire — this allows partial updates to pass through gracefully
     * when only some dates are being changed.
     */
    private void validateSchedule(
            LocalDateTime regStart,
            LocalDateTime regEnd,
            LocalDateTime eventStart,
            LocalDateTime eventEnd) {

        // Rule 1: registration start < registration end
        if (regStart != null && regEnd != null) {
            if (!regEnd.isAfter(regStart)) {
                throw new IllegalArgumentException(
                        "Registration end must be after registration start");
            }
        }

        // Rule 2: registration end <= event start
        if (regEnd != null && eventStart != null) {
            if (eventStart.isBefore(regEnd)) {
                throw new IllegalArgumentException(
                        "Registration end must be on or before the event start date/time");
            }
        }

        // Rule 3: event start < event end (only when end is provided)
        if (eventEnd != null && eventStart != null) {
            if (!eventEnd.isAfter(eventStart)) {
                throw new IllegalArgumentException(
                        "Event end date/time must be after event start date/time");
            }
        }
    }
}
