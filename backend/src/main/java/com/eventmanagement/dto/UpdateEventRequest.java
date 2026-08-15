package com.eventmanagement.dto;

import com.eventmanagement.entity.EventStatus;
import jakarta.validation.constraints.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * All fields are optional on update.
 *
 * Special handling for endDateTime:
 *   - absent from JSON  → field is null in Java  → not modified (existing value kept)
 *   - explicitly "endDateTime": null in JSON  → field is null but the request signals removal
 *
 * To distinguish "not provided" from "explicitly set to null" we use a boolean flag
 * removeEndDateTime that Flutter sets to true when the organizer wants to clear the end time.
 */
public class UpdateEventRequest {

    @Size(min = 3, max = 200, message = "Title must be between 3 and 200 characters")
    private String title;

    private String description;
    private String category;
    private String venue;
    private String address;
    private String city;

    // Registration period — both optional on update
    private LocalDateTime registrationStartDateTime;
    private LocalDateTime registrationEndDateTime;

    // Event schedule
    private LocalDateTime startDateTime;

    /**
     * New event end time, or null.
     * Combined with removeEndDateTime to distinguish "not changed" vs "explicitly cleared".
     */
    private LocalDateTime endDateTime;

    /**
     * When true, the existing endDateTime is cleared (set to null).
     * When false (default), endDateTime is only changed if a non-null value is provided.
     */
    private boolean removeEndDateTime = false;

    @DecimalMin(value = "0.00", message = "Ticket price must not be negative")
    private BigDecimal ticketPrice;

    @Min(value = 1, message = "Capacity must be greater than zero")
    private Integer capacity;

    private EventStatus status;

    // ── Getters and Setters ───────────────────────────────────────────────────

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

    public boolean isRemoveEndDateTime() { return removeEndDateTime; }
    public void setRemoveEndDateTime(boolean removeEndDateTime) { this.removeEndDateTime = removeEndDateTime; }

    public BigDecimal getTicketPrice() { return ticketPrice; }
    public void setTicketPrice(BigDecimal ticketPrice) { this.ticketPrice = ticketPrice; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public EventStatus getStatus() { return status; }
    public void setStatus(EventStatus status) { this.status = status; }
}
