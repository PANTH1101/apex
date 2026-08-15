package com.eventmanagement.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "events")
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "organizer_id", nullable = false)
    private User organizer;

    @NotBlank(message = "Title is required")
    @Size(min = 3, max = 200, message = "Title must be between 3 and 200 characters")
    @Column(nullable = false, length = 200)
    private String title;

    @NotBlank(message = "Description is required")
    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @NotBlank(message = "Category is required")
    @Column(nullable = false, length = 100)
    private String category;

    @NotBlank(message = "Venue is required")
    @Column(nullable = false, length = 200)
    private String venue;

    @NotBlank(message = "Address is required")
    @Column(nullable = false, length = 300)
    private String address;

    @NotBlank(message = "City is required")
    @Column(nullable = false, length = 100)
    private String city;

    // ── Registration period (REQUIRED) ────────────────────────────────────────
    @NotNull(message = "Registration start date/time is required")
    @Column(nullable = false)
    private LocalDateTime registrationStartDateTime;

    @NotNull(message = "Registration end date/time is required")
    @Column(nullable = false)
    private LocalDateTime registrationEndDateTime;

    // ── Event schedule ────────────────────────────────────────────────────────
    @NotNull(message = "Event start date/time is required")
    @Column(nullable = false)
    private LocalDateTime startDateTime;

    // endDateTime is intentionally nullable — event end time is optional
    @Column(nullable = true)
    private LocalDateTime endDateTime;

    @NotNull(message = "Ticket price is required")
    @DecimalMin(value = "0.00", message = "Ticket price must not be negative")
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal ticketPrice;

    @NotNull(message = "Capacity is required")
    @Min(value = 1, message = "Capacity must be greater than zero")
    @Column(nullable = false)
    private Integer capacity;

    @Column(nullable = false)
    private Integer availableTickets;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private EventStatus status = EventStatus.PUBLISHED;

    @Column(length = 512)
    private String imageUrl;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;

    public Event() {
    }

    // ── Getters and Setters ───────────────────────────────────────────────────

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getOrganizer() { return organizer; }
    public void setOrganizer(User organizer) { this.organizer = organizer; }

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
    public void setRegistrationStartDateTime(LocalDateTime registrationStartDateTime) {
        this.registrationStartDateTime = registrationStartDateTime;
    }

    public LocalDateTime getRegistrationEndDateTime() { return registrationEndDateTime; }
    public void setRegistrationEndDateTime(LocalDateTime registrationEndDateTime) {
        this.registrationEndDateTime = registrationEndDateTime;
    }

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
