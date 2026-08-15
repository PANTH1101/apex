package com.eventmanagement.dto;

import com.eventmanagement.entity.Event;
import com.eventmanagement.entity.EventStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class EventResponse {

    private Long id;
    private Long organizerId;
    private String organizerName;
    private String title;
    private String description;
    private String category;
    private String venue;
    private String address;
    private String city;

    // Registration period
    private LocalDateTime registrationStartDateTime;
    private LocalDateTime registrationEndDateTime;

    // Event schedule
    private LocalDateTime startDateTime;
    private LocalDateTime endDateTime; // nullable

    private BigDecimal ticketPrice;
    private Integer capacity;
    private Integer availableTickets;
    private EventStatus status;
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public EventResponse() {
    }

    public static EventResponse fromEvent(Event event) {
        EventResponse r = new EventResponse();
        r.id = event.getId();
        r.organizerId = event.getOrganizer().getId();
        r.organizerName = event.getOrganizer().getName();
        r.title = event.getTitle();
        r.description = event.getDescription();
        r.category = event.getCategory();
        r.venue = event.getVenue();
        r.address = event.getAddress();
        r.city = event.getCity();
        r.registrationStartDateTime = event.getRegistrationStartDateTime();
        r.registrationEndDateTime = event.getRegistrationEndDateTime();
        r.startDateTime = event.getStartDateTime();
        r.endDateTime = event.getEndDateTime(); // may be null
        r.ticketPrice = event.getTicketPrice();
        r.capacity = event.getCapacity();
        r.availableTickets = event.getAvailableTickets();
        r.status = event.getStatus();
        r.imageUrl = event.getImageUrl();
        r.createdAt = event.getCreatedAt();
        r.updatedAt = event.getUpdatedAt();
        return r;
    }

    // ── Getters and Setters ───────────────────────────────────────────────────

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getOrganizerId() { return organizerId; }
    public void setOrganizerId(Long organizerId) { this.organizerId = organizerId; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public LocalDateTime getRegistrationStartDateTime() { return registrationStartDateTime; }
    public void setRegistrationStartDateTime(LocalDateTime v) { this.registrationStartDateTime = v; }

    public LocalDateTime getRegistrationEndDateTime() { return registrationEndDateTime; }
    public void setRegistrationEndDateTime(LocalDateTime v) { this.registrationEndDateTime = v; }

    public LocalDateTime getStartDateTime() { return startDateTime; }
    public void setStartDateTime(LocalDateTime startDateTime) { this.startDateTime = startDateTime; }

    public LocalDateTime getEndDateTime() { return endDateTime; }
    public void setEndDateTime(LocalDateTime endDateTime) { this.endDateTime = endDateTime; }

    public BigDecimal getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(BigDecimal ticketPrice) { this.ticketPrice = ticketPrice; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public Integer getAvailableTickets() { return availableTickets; }
    public void setAvailableTickets(Integer availableTickets) { this.availableTickets = availableTickets; }

    public EventStatus getStatus() { return status; }
    public void setStatus(EventStatus status) { this.status = status; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
