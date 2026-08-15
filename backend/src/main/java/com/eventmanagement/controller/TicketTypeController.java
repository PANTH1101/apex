package com.eventmanagement.controller;

import com.eventmanagement.dto.CreateTicketTypeRequest;
import com.eventmanagement.dto.TicketTypeResponse;
import com.eventmanagement.dto.UpdateTicketTypeRequest;
import com.eventmanagement.service.TicketTypeService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events/{eventId}/ticket-types")
public class TicketTypeController {

    private final TicketTypeService ticketTypeService;

    public TicketTypeController(TicketTypeService ticketTypeService) {
        this.ticketTypeService = ticketTypeService;
    }

    /**
     * GET /api/events/{eventId}/ticket-types
     * Get all ticket types for an event.
     * Any authenticated user can access this (attendees can view ticket options).
     */
    @GetMapping
    public ResponseEntity<List<TicketTypeResponse>> getTicketTypes(@PathVariable Long eventId) {
        List<TicketTypeResponse> ticketTypes = ticketTypeService.getTicketTypesByEvent(eventId);
        return ResponseEntity.ok(ticketTypes);
    }

    /**
     * GET /api/events/{eventId}/ticket-types/{ticketTypeId}
     * Get a specific ticket type by ID.
     * Any authenticated user can access this.
     */
    @GetMapping("/{ticketTypeId}")
    public ResponseEntity<TicketTypeResponse> getTicketType(
            @PathVariable Long eventId,
            @PathVariable Long ticketTypeId) {
        TicketTypeResponse ticketType = ticketTypeService.getTicketTypeById(eventId, ticketTypeId);
        return ResponseEntity.ok(ticketType);
    }

    /**
     * POST /api/events/{eventId}/ticket-types
     * Create a new ticket type for an event.
     * Only ORGANIZER role allowed and must own the event.
     */
    @PostMapping
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<TicketTypeResponse> createTicketType(
            @PathVariable Long eventId,
            @Valid @RequestBody CreateTicketTypeRequest request,
            Authentication authentication) {
        String organizerEmail = authentication.getName();
        TicketTypeResponse response = ticketTypeService.createTicketType(eventId, request, organizerEmail);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * PUT /api/events/{eventId}/ticket-types/{ticketTypeId}
     * Update a ticket type.
     * Only ORGANIZER role allowed and must own the event.
     */
    @PutMapping("/{ticketTypeId}")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<TicketTypeResponse> updateTicketType(
            @PathVariable Long eventId,
            @PathVariable Long ticketTypeId,
            @Valid @RequestBody UpdateTicketTypeRequest request,
            Authentication authentication) {
        String organizerEmail = authentication.getName();
        TicketTypeResponse response = ticketTypeService.updateTicketType(eventId, ticketTypeId, request, organizerEmail);
        return ResponseEntity.ok(response);
    }

    /**
     * DELETE /api/events/{eventId}/ticket-types/{ticketTypeId}
     * Delete a ticket type.
     * Only ORGANIZER role allowed and must own the event.
     */
    @DeleteMapping("/{ticketTypeId}")
    @PreAuthorize("hasRole('ORGANIZER')")
    public ResponseEntity<Void> deleteTicketType(
            @PathVariable Long eventId,
            @PathVariable Long ticketTypeId,
            Authentication authentication) {
        String organizerEmail = authentication.getName();
        ticketTypeService.deleteTicketType(eventId, ticketTypeId, organizerEmail);
        return ResponseEntity.noContent().build();
    }
}