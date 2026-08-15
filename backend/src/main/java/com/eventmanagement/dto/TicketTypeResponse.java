package com.eventmanagement.dto;

import com.eventmanagement.entity.TicketType;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TicketTypeResponse {

    private Long id;
    private Long eventId;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer capacity;
    private Integer availableQuantity;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public TicketTypeResponse() {
    }

    public static TicketTypeResponse fromTicketType(TicketType ticketType) {
        TicketTypeResponse response = new TicketTypeResponse();
        response.setId(ticketType.getId());
        response.setEventId(ticketType.getEvent().getId());
        response.setName(ticketType.getName());
        response.setDescription(ticketType.getDescription());
        response.setPrice(ticketType.getPrice());
        response.setCapacity(ticketType.getCapacity());
        response.setAvailableQuantity(ticketType.getAvailableQuantity());
        response.setCreatedAt(ticketType.getCreatedAt());
        response.setUpdatedAt(ticketType.getUpdatedAt());
        return response;
    }

    // ── Getters and Setters ───────────────────────────────────────────────────

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getEventId() { return eventId; }
    public void setEventId(Long eventId) { this.eventId = eventId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public Integer getAvailableQuantity() { return availableQuantity; }
    public void setAvailableQuantity(Integer availableQuantity) { this.availableQuantity = availableQuantity; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}