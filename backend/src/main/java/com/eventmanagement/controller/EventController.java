package com.eventmanagement.controller;

import com.eventmanagement.dto.CreateEventRequest;
import com.eventmanagement.dto.EventResponse;
import com.eventmanagement.dto.UpdateEventRequest;
import com.eventmanagement.service.EventService;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
     * GET /api/events
     * Attendee event discovery: returns PUBLISHED events only.
     * All query parameters are optional and combinable.
     *
     * @param keyword   free-text search (title, description, category, venue, city)
     * @param category  exact category filter
     * @param startDate ISO date lower bound on event start (inclusive)
     * @param endDate   ISO date upper bound on event start (inclusive)
     */
    @GetMapping
    public ResponseEntity<List<EventResponse>> discoverEvents(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        // Convert LocalDate bounds to LocalDateTime (start of day / end of day)
        LocalDateTime startDt = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endDt   = endDate   != null ? endDate.atTime(23, 59, 59) : null;

        List<EventResponse> events = eventService.discoverEvents(keyword, category, startDt, endDt);
        return ResponseEntity.ok(events);
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

    /**
     * POST /api/events/{id}/image
     * Upload or replace the primary image for an event.
     * Only the owning ORGANIZER can upload images.
     *
     * Expects multipart/form-data with field name "image".
     */
    @PostMapping(value = "/{id}/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventResponse> uploadEventImage(
            @PathVariable Long id,
            @RequestParam("image") MultipartFile image,
            Authentication authentication) throws IOException {

        String organizerEmail = authentication.getName();
        EventResponse response = eventService.uploadImage(id, image, organizerEmail);
        return ResponseEntity.ok(response);
    }

    /**
     * DELETE /api/events/{id}/image
     * Remove the image from an event.
     * Only the owning ORGANIZER can remove images.
     */
    @DeleteMapping("/{id}/image")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<EventResponse> removeEventImage(
            @PathVariable Long id,
            Authentication authentication) {

        String organizerEmail = authentication.getName();
        EventResponse response = eventService.removeImage(id, organizerEmail);
        return ResponseEntity.ok(response);
    }
}
