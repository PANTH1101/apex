package com.eventmanagement.repository;

import com.eventmanagement.entity.Event;
import com.eventmanagement.entity.TicketType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TicketTypeRepository extends JpaRepository<TicketType, Long> {

    /**
     * Find all ticket types for a specific event, ordered by price ascending.
     */
    List<TicketType> findByEventOrderByPriceAsc(Event event);

    /**
     * Find all ticket types for a specific event by event ID, ordered by price ascending.
     */
    List<TicketType> findByEventIdOrderByPriceAsc(Long eventId);

    /**
     * Find a ticket type by event and name (case insensitive).
     * Used to check for duplicate names within the same event.
     */
    Optional<TicketType> findByEventAndNameIgnoreCase(Event event, String name);

    /**
     * Find a ticket type by event ID and ticket type ID.
     * Used to verify ownership before update/delete operations.
     */
    Optional<TicketType> findByEventIdAndId(Long eventId, Long ticketTypeId);

    /**
     * Count ticket types for a specific event.
     */
    long countByEventId(Long eventId);
}