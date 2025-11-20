// ./src/app/page.tsx
"use client";

import { ConnectButton } from "@/components/ConnectButton";
import { InfoList } from "@/components/InfoList";
import { ActionButtonList } from "@/components/ActionButtonList";
import { SignMessage } from "@/components/SignMessage";
import { CreateCampaign } from "@/components/CreateCampaign";
import Image from 'next/image';
import { useState, useEffect } from 'react';

export default function Home() {
  const [mounted, setMounted] = useState(false);
  const [activeSection, setActiveSection] = useState<string | null>(null);

  useEffect(() => {
    setMounted(true);
  }, []);

  const handleSectionClick = (section: string) => {
    setActiveSection(activeSection === section ? null : section);
  };

  return (
    <div className="pages">
      {/* Hero Section with Animated Background */}
      <header className={`hero-section ${mounted ? 'fade-in' : ''}`}>
        <div className="animated-background">
          <div className="gradient-orb orb-1"></div>
          <div className="gradient-orb orb-2"></div>
          <div className="gradient-orb orb-3"></div>
        </div>

        <div className="logo-container pulse-animation">
          <Image
            src="/reown.svg"
            alt="Reown"
            width={80}
            height={80}
            priority
          />
        </div>

        <h1 className="main-title slide-up">
          educational-sandbox
        </h1>

        <p className="hero-description slide-up delay-1">
          A decentralized educational-sandbox testing platform built on blockchain technology
        </p>

        <div className="hero-features slide-up delay-2">
          <div className="feature-badge hover-lift">
            <span className="badge-icon">🔐</span>
            Secure
          </div>
          <div className="feature-badge hover-lift">
            <span className="badge-icon">⚡</span>
            Fast
          </div>
          <div className="feature-badge hover-lift">
            <span className="badge-icon">🌐</span>
            Decentralized
          </div>
        </div>

        {/* Scroll Indicator */}
        <div className="scroll-indicator">
          <div className="mouse">
            <div className="wheel"></div>
          </div>
          <div className="arrow-down">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      </header>

      {/* Stats Bar */}
      <div className="stats-bar slide-up delay-3">
        <div className="stat-item">
          <div className="stat-icon">👥</div>
          <div className="stat-content">
            <div className="stat-value counter" data-target="1000">0</div>
            <div className="stat-label">Users</div>
          </div>
        </div>
        <div className="stat-divider"></div>
        <div className="stat-item">
          <div className="stat-icon">🚀</div>
          <div className="stat-content">
            <div className="stat-value counter" data-target="250">0</div>
            <div className="stat-label">Campaigns</div>
          </div>
        </div>
        <div className="stat-divider"></div>
        <div className="stat-item">
          <div className="stat-icon">💰</div>
          <div className="stat-content">
            <div className="stat-value">$2.5M+</div>
            <div className="stat-label">Funded</div>
          </div>
        </div>
      </div>

      {/* Connection Section with Enhanced Styling */}
      <section className="connection-section card-hover">
        <div className="section-header">
          <div className="section-icon-wrapper">
            <span className="section-icon">🔌</span>
          </div>
          <div>
            <h2 className="section-title">Get Started</h2>
            <p className="section-description">
              Connect your wallet to start using the educational-sandbox testing platform
            </p>
          </div>
        </div>

        <div className="connection-content">
          <ConnectButton />
          <div className="action-buttons-wrapper">
            <ActionButtonList />
          </div>
        </div>

        {/* Progress Indicator */}
        <div className="progress-steps">
          <div className="step completed">
            <div className="step-circle">1</div>
            <div className="step-label">Connect Wallet</div>
          </div>
          <div className="step-line"></div>
          <div className="step">
            <div className="step-circle">2</div>
            <div className="step-label">Create Campaign</div>
          </div>
          <div className="step-line"></div>
          <div className="step">
            <div className="step-circle">3</div>
            <div className="step-label">Start Funding</div>
          </div>
        </div>
      </section>

      {/* Campaign Creation Section - Enhanced */}
      <section
        className={`campaign-section card-hover ${activeSection === 'campaign' ? 'expanded' : ''}`}
        onClick={() => handleSectionClick('campaign')}
      >
        <div className="feature-card campaign-card glass-effect">
          <div className="feature-card-header">
            <span className="feature-icon rotate-on-hover">🚀</span>
            <div>
              <h2>Create Campaign</h2>
              <span className="badge new-badge">New</span>
            </div>
          </div>
          <p className="feature-description">
            Launch a new crowdfunding campaign with blockchain transparency and immutable records
          </p>

          {/* Campaign Features */}
          <div className="mini-features">
            <div className="mini-feature">
              <span className="mini-icon">✅</span>
              <span>Transparent</span>
            </div>
            <div className="mini-feature">
              <span className="mini-icon">🔒</span>
              <span>Secure</span>
            </div>
            <div className="mini-feature">
              <span className="mini-icon">⚡</span>
              <span>Instant</span>
            </div>
          </div>

          <CreateCampaign />
        </div>
      </section>

      {/* Main Features Grid with Stagger Animation */}
      <div className="features-grid">
        {/* Sign Message Feature */}
        <div className="feature-card card-hover stagger-1">
          <div className="card-glow"></div>
          <div className="feature-card-header">
            <span className="feature-icon bounce-on-hover">✍️</span>
            <h2>Message Signing</h2>
          </div>
          <p className="feature-description">
            Sign messages securely with your connected wallet using cryptographic signatures
          </p>

          <div className="feature-stats">
            <div className="feature-stat">
              <span className="stat-icon-small">🔐</span>
              <span>Military-grade encryption</span>
            </div>
          </div>

          <SignMessage />
        </div>

        {/* Info Panel */}
        <div className="feature-card info-card card-hover stagger-2">
          <div className="card-glow"></div>
          <div className="feature-card-header">
            <span className="feature-icon pulse-icon">ℹ️</span>
            <h2>Connection Info</h2>
          </div>
          <p className="feature-description">
            View your wallet connection details, network information, and transaction history
          </p>

          <div className="feature-stats">
            <div className="feature-stat">
              <span className="stat-icon-small">🌐</span>
              <span>Real-time updates</span>
            </div>
          </div>

          <InfoList />
        </div>
      </div>

      {/* Additional Info Section */}
      <section className="info-section glass-effect">
        <h2 className="section-title centered">Why Choose Us?</h2>
        <div className="benefits-grid">
          <div className="benefit-item">
            <div className="benefit-icon">🛡️</div>
            <h3>Security First</h3>
            <p>Built with industry-leading security practices</p>
          </div>
          <div className="benefit-item">
            <div className="benefit-icon">⚡</div>
            <h3>Lightning Fast</h3>
            <p>Optimized for speed and performance</p>
          </div>
          <div className="benefit-item">
            <div className="benefit-icon">🌍</div>
            <h3>Global Access</h3>
            <p>Available anywhere, anytime</p>
          </div>
          <div className="benefit-item">
            <div className="benefit-icon">💎</div>
            <h3>Low Fees</h3>
            <p>Minimal transaction costs</p>
          </div>
        </div>
      </section>

      {/* Footer with Enhanced Design */}
      <footer className="footer">
        <div className="footer-content">
          <div className="footer-brand">
            <Image
              src="/reown.svg"
              alt="Reown"
              width={40}
              height={40}
            />
            <h3>educational-sandbox</h3>
          </div>

          <p className="footer-text">
            Built with modern Web3 technologies for the decentralized future
          </p>

          <div className="footer-links">
            <a
              href="https://reown.com"
              target="_blank"
              rel="noopener noreferrer"
              className="footer-link hover-lift"
            >
              <span className="link-icon">🔗</span>
              Reown
            </a>
            <span className="footer-separator">•</span>
            <a
              href="https://wagmi.sh"
              target="_blank"
              rel="noopener noreferrer"
              className="footer-link hover-lift"
            >
              <span className="link-icon">⚙️</span>
              Wagmi
            </a>
            <span className="footer-separator">•</span>
            <a
              href="https://github.com"
              target="_blank"
              rel="noopener noreferrer"
              className="footer-link hover-lift"
            >
              <span className="link-icon">💻</span>
              GitHub
            </a>
          </div>

          <div className="footer-bottom">
            <p>© 2024 educational-sandbox. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}