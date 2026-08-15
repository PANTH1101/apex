package com.eventmanagement.controller;

import com.eventmanagement.dto.CreateEventRequest;
import com.eventmanagement.dto.EventResponse;
import com.eventmanagement.dto.UpdateEventRequest;
import com.eventmanagement.service.EventService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events")
public class EventController {

    private final EventService eventService;

    public EventController(EventService eventService) {
        this.eventService = eventService;
    }

    /**
     * POST /api/events
     * Create a new event. Only ORGANIZER role allowed.
     * Organizer identity is taken from the JWT, not from the request body.
     */
    @PostMapping
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventResponse> createEvent(
            @Valid @RequestBody CreateEventRequest request,
            Authentication authentication) {

        String organizerEmail = authentication.getName();
        EventResponse response = eventService.createEvent(request, organizerEmail);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * GET /api/events/{id}
     * Get a single event by ID. Any authenticated user can access.
     */
    @GetMapping("/{id}")
    public ResponseEntity<EventResponse> getEventById(@PathVariable Long id) {
        EventResponse response = eventService.getEventById(id);
        return ResponseEntity.ok(response);
    }

    /**
     * GET /api/events/my
     * Get all events belonging to the authenticated organizer.
     * Only ORGANIZER role allowed.
     */
    @GetMapping("/my")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<List<EventResponse>> getMyEvents(Authentication authentication) {
        String organizerEmail = authentication.getName();
        List<EventResponse> events = eventService.getOrganizerEvents(organizerEmail);
        return ResponseEntity.ok(events);
    }

    /**
     * PUT /api/events/{id}
     * Update an event. Only the owning ORGANIZER can update.
     * Ownership is verified inside EventService against the JWT identity.
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventResponse> updateEvent(
            @PathVariable Long id,
            @Valid @RequestBody UpdateEventRequest request,
            Authentication authentication) {

        String organizerEmail = authentication.getName();
        EventResponse response = eventService.updateEvent(id, request, organizerEmail);
        return ResponseEntity.ok(response);
    }

    /**
     * DELETE /api/events/{id}
     * Delete an event. Only the owning ORGANIZER can delete.
     * Ownership is verified inside EventService against the JWT identity.
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<Void> deleteEvent(
            @PathVariable Long id,
            Authentication authentication) {

        String organizerEmail = authentication.getName();
        eventService.deleteEvent(id, organizerEmail);
        return ResponseEntity.noContent().build();
    }
}
