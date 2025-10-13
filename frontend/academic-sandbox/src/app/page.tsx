// ./src/app/page.tsx
import { ConnectButton } from "@/components/ConnectButton";
import { InfoList } from "@/components/InfoList";
import { ActionButtonList } from "@/components/ActionButtonList";
import Image from 'next/image';

export default function Home() {
  return (
    <div className={"pages"}>
      <Image
        src="/reown.svg"
        alt="Reown"
        width={150}
        height={150}
        priority
      />
      <h1>Academic Sandbox</h1>
      <p className="subtitle">Ideas Run while In Here!</p>

      <ConnectButton />
      <ActionButtonList />

      <div className="info-section">
        <InfoList />
      </div>

      <footer className="footer">
        <p>
          Powered by{' '}
          <a
            href="https://reown.com"
            target="_blank"
            rel="noopener noreferrer"
            className="link-button"
          >
            Reown
          </a>
          {' '}and{' '}
          <a
            href="https://wagmi.sh"
            target="_blank"
            rel="noopener noreferrer"
            className="link-button"
          >
            Wagmi
          </a>
        </p>
      </footer>
    </div>
  );
}