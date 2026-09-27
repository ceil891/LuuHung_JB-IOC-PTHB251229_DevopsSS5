package com.quickbite.user;

import jakarta.persistence.*;

@Entity
@Table(name = "user_wallets")
public class UserWallet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private java.math.BigDecimal balance = java.math.BigDecimal.ZERO;
    @OneToOne(optional = false)
    @JoinColumn(name = "user_id", unique = true)
    private User user;

    protected UserWallet() {}
}
