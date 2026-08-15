package com.eventmanagement.service;

import com.eventmanagement.dto.CreateTicketTypeRequest;
import com.eventmanagement.dto.TicketTypeResponse;
import com.eventmanagement.dto.UpdateTicketTypeRequest;
import com.eventmanagement.entity.Event;
import com.eventmanagement.entity.TicketType;
import com.eventmanagement.exception.ForbiddenException;
import com.eventmanagement.exception.ResourceNotFoundException;
import com.eventmanagement.repository.EventRepository;
import com.eventmanagement.repository.TicketTypeRepository;
import com.eventmanagement.repository.UserRepository;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class TicketTypeService {

    private final TicketTypeRepository ticketTypeRepository;
    private final EventRepository eventRepository;
    private final UserRepository userRepository;

    public TicketTypeService(TicketTypeRepository ticketTypeRepository,
                            EventRepository eventRepository,
                            UserRepository userRepository) {
        this.ticketTypeRepository = ticketTypeRepository;
        this.eventRepository = eventRepository;
        this.userRepository = userRepository;
    }

    // ── Create ────────────────────────────────────────────────────────────────

    @Transactional
    public TicketTypeResponse createTicketType(Long eventId, CreateTicketTypeRequest request, String organizerEmail) {
        Event event = findEventOrThrow(eventId);
        assertEventOwnership(event, organizerEmail);

        // Check for duplicate name within the same event
        Optional<TicketType> existingTicketType = ticketTypeRepository.findByEventAndNameIgnoreCase(event, request.getName());
        if (existingTicketType.isPresent()) {
            throw new IllegalArgumentException("A ticket type with the name '" + request.getName() + "' already exists for this event");
        }

        TicketType ticketType = new TicketType();
        ticketType.setEvent(event);
        ticketType.setName(request.getName().trim());
        ticketType.setDescription(request.getDescription() != null ? request.getDescription().trim() : null);
        ticketType.setPrice(request.getPrice());
        ticketType.setCapacity(request.getCapacity());
        // Initialize availableQuantity equal to capacity
        ticketType.setAvailableQuantity(request.getCapacity());

        return TicketTypeResponse.fromTicketType(ticketTypeRepository.save(ticketType));
    }

    // ── Read ──────────────────────────────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<TicketTypeResponse> getTicketTypesByEvent(Long eventId) {
        // Verify event exists (throws exception if not found)
        findEventOrThrow(eventId);
        
        return ticketTypeRepository.findByEventIdOrderByPriceAsc(eventId)
                .stream()
                .map(TicketTypeResponse::fromTicketType)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public TicketTypeResponse getTicketTypeById(Long eventId, Long ticketTypeId) {
        TicketType ticketType = findTicketTypeOrThrow(eventId, ticketTypeId);
        return TicketTypeResponse.fromTicketType(ticketType);
    }

    // ── Update ────────────────────────────────────────────────────────────────

    @Transactional
    public TicketTypeResponse updateTicketType(Long eventId, Long ticketTypeId, UpdateTicketTypeRequest request, String organizerEmail) {
        TicketType ticketType = findTicketTypeOrThrow(eventId, ticketTypeId);
        assertEventOwnership(ticketType.getEvent(), organizerEmail);

        // Check for duplicate name if name is being changed
        if (request.getName() != null && !request.getName().trim().equalsIgnoreCase(ticketType.getName())) {
            Optional<TicketType> existingTicketType = ticketTypeRepository.findByEventAndNameIgnoreCase(ticketType.getEvent(), request.getName());
            if (existingTicketType.isPresent()) {
                throw new IllegalArgumentException("A ticket type with the name '" + request.getName() + "' already exists for this event");
            }
            ticketType.setName(request.getName().trim());
        }

        if (request.getDescription() != null) {
            ticketType.setDescription(request.getDescription().trim().isEmpty() ? null : request.getDescription().trim());
        }

        if (request.getPrice() != null) {
            ticketType.setPrice(request.getPrice());
        }

        if (request.getCapacity() != null) {
            // Validate that capacity is not less than current available quantity
            if (request.getCapacity() < ticketType.getAvailableQuantity()) {
                throw new IllegalArgumentException("Capacity cannot be less than available quantity (" + ticketType.getAvailableQuantity() + ")");
            }
            
            // Update available quantity proportionally if capacity increases
            int capacityDifference = request.getCapacity() - ticketType.getCapacity();
            ticketType.setCapacity(request.getCapacity());
            ticketType.setAvailableQuantity(ticketType.getAvailableQuantity() + capacityDifference);
        }

        return TicketTypeResponse.fromTicketType(ticketTypeRepository.save(ticketType));
    }

    // ── Delete ────────────────────────────────────────────────────────────────

    @Transactional
    public void deleteTicketType(Long eventId, Long ticketTypeId, String organizerEmail) {
        TicketType ticketType = findTicketTypeOrThrow(eventId, ticketTypeId);
        assertEventOwnership(ticketType.getEvent(), organizerEmail);

        // In Phase 3A, we can delete freely since no bookings exist yet
        // Phase 3B will add booking validation here
        ticketTypeRepository.delete(ticketType);
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    private Event findEventOrThrow(Long eventId) {
        return eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
    }

    private TicketType findTicketTypeOrThrow(Long eventId, Long ticketTypeId) {
        return ticketTypeRepository.findByEventIdAndId(eventId, ticketTypeId)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket type not found with id: " + ticketTypeId + " for event: " + eventId));
    }

    private void assertEventOwnership(Event event, String authenticatedEmail) {
        if (!event.getOrganizer().getEmail().equals(authenticatedEmail)) {
            throw new ForbiddenException("You do not have permission to modify ticket types for this event");
        }
    }
}