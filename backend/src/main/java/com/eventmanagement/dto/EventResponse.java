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
    private LocalDateTime startDateTime;
    private LocalDateTime endDateTime;
    private BigDecimal ticketPrice;
    private Integer capacity;
    private Integer availableTickets;
    private EventStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public EventResponse() {
    }

    // Factory method — consistent with Phase 1 UserResponse.fromUser() pattern
    public static EventResponse fromEvent(Event event) {
        EventResponse response = new EventResponse();
        response.id = event.getId();
        response.organizerId = event.getOrganizer().getId();
        response.organizerName = event.getOrganizer().getName();
        response.title = event.getTitle();
        response.description = event.getDescription();
        response.category = event.getCategory();
        response.venue = event.getVenue();
        response.address = event.getAddress();
        response.city = event.getCity();
        response.startDateTime = event.getStartDateTime();
        response.endDateTime = event.getEndDateTime();
        response.ticketPrice = event.getTicketPrice();
        response.capacity = event.getCapacity();
        response.availableTickets = event.getAvailableTickets();
        response.status = event.getStatus();
        response.createdAt = event.getCreatedAt();
        response.updatedAt = event.getUpdatedAt();
        return response;
    }

    // Getters and Setters
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

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
