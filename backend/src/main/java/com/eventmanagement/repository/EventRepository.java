package com.eventmanagement.repository;

import com.eventmanagement.entity.Event;
import com.eventmanagement.entity.EventStatus;
import com.eventmanagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface EventRepository extends JpaRepository<Event, Long> {

    List<Event> findByOrganizer(User organizer);

    List<Event> findByOrganizerId(Long organizerId);

    /**
     * Attendee discovery query.
     *
     * Returns only PUBLISHED and UPCOMING events ordered by startDateTime ascending (soonest first).
     * All filter parameters are optional — passing null skips that filter.
     *
     * keyword   : case-insensitive LIKE match against title, description, category, venue, city
     * category  : exact match (case-insensitive)
     * startDate : event.startDateTime >= startDate
     * endDate   : event.startDateTime <= endDate
     *
     * IMPORTANT: Only returns events where startDateTime >= CURRENT_TIMESTAMP (upcoming events only)
     */
    @Query("""
        SELECT e FROM Event e
        WHERE e.status = :status
          AND e.startDateTime >= CURRENT_TIMESTAMP
          AND (:keyword IS NULL OR :keyword = ''
               OR LOWER(e.title)       LIKE LOWER(CONCAT('%', :keyword, '%'))
               OR LOWER(e.description) LIKE LOWER(CONCAT('%', :keyword, '%'))
               OR LOWER(e.category)    LIKE LOWER(CONCAT('%', :keyword, '%'))
               OR LOWER(e.venue)       LIKE LOWER(CONCAT('%', :keyword, '%'))
               OR LOWER(e.city)        LIKE LOWER(CONCAT('%', :keyword, '%')))
          AND (:category IS NULL OR :category = ''
               OR LOWER(e.category) = LOWER(:category))
          AND (:startDate IS NULL OR e.startDateTime >= :startDate)
          AND (:endDate   IS NULL OR e.startDateTime <= :endDate)
        ORDER BY e.startDateTime ASC
        """)
    List<Event> findDiscoverableEvents(
            @Param("status")    EventStatus status,
            @Param("keyword")   String keyword,
            @Param("category")  String category,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate")   LocalDateTime endDate
    );
}
