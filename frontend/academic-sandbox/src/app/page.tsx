// ./src/app/page.tsx
import { ConnectButton } from "@/components/ConnectButton";
import { InfoList } from "@/components/InfoList";
import { ActionButtonList } from "@/components/ActionButtonList";
import { SignMessage } from "@/components/SignMessage";
import Image from 'next/image';

export default function Home() {
  return (
    <div className="pages">
      {/* Hero Section */}
      <header className="hero-section">
        <div className="logo-container">
          <Image 
            src="/reown.svg" 
            alt="Reown" 
            width={80} 
            height={80} 
            priority 
          />
        </div>
        <h1 className="main-title">AB System</h1>
        <p className="hero-description">
          A decentralized A/B testing platform built on blockchain technology
        </p>
        <div className="hero-features">
          <div className="feature-badge">🔐 Secure</div>
          <div className="feature-badge">⚡ Fast</div>
          <div className="feature-badge">🌐 Decentralized</div>
        </div>
      </header>

      {/* Connection Section */}
      <section className="connection-section">
        <h2 className="section-title">Get Started</h2>
        <p className="section-description">
          Connect your wallet to start using the A/B testing system
        </p>
        <ConnectButton />
        <div className="action-buttons-wrapper">
          <ActionButtonList />
        </div>
      </section>

      {/* Main Features Grid */}
      <div className="features-grid">
        {/* Sign Message Feature */}
        <div className="feature-card">
          <div className="feature-card-header">
            <span className="feature-icon">✍️</span>
            <h2>Message Signing</h2>
          </div>
          <p className="feature-description">
            Sign messages securely with your connected wallet
          </p>
          <SignMessage />
        </div>

        {/* Info Panel */}
        <div className="feature-card info-card">
          <div className="feature-card-header">
            <span className="feature-icon">ℹ️</span>
            <h2>Connection Info</h2>
          </div>
          <p className="feature-description">
            View your wallet connection details and network information
          </p>
          <InfoList />
        </div>
      </div>

      {/* Footer */}
      <footer className="footer">
        <div className="footer-content">
          <p className="footer-text">Built with modern Web3 technologies</p>
          <div className="footer-links">
            <a 
              href="https://reown.com" 
              target="_blank" 
              rel="noopener noreferrer"
              className="footer-link"
            >
              <span className="link-icon">🔗</span>
              Reown
            </a>
            <span className="footer-separator">•</span>
            <a 
              href="https://wagmi.sh" 
              target="_blank" 
              rel="noopener noreferrer"
              className="footer-link"
            >
              <span className="link-icon">⚙️</span>
              Wagmi
            </a>
          </div>
        </div>
      </footer>
    </div>
  );
}