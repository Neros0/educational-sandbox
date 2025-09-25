"use client";

import { wagmiAdapter, projectId, networks } from "@/app/config";
import { createAppKit, getAppKit } from "@reown/appkit/react";
import { base } from "@reown/appkit/networks";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React, { ReactNode, useEffect, useState } from "react";
import { cookieToInitialState, WagmiProvider, type Config, useAccount } from "wagmi";

const queryClient = new QueryClient();

if (!projectId) throw new Error("NEXT_PUBLIC_PROJECT_ID is not defined");

const metadata = {
    name: "Academic Sandbox",
    description: "An AI-powered educational sandbox.",
    url: "https://educational-sandbox.vercel.app/",
    icons: ["https://educational-sandbox.vercel.app/favicon.ico"],
};

// Initialize AppKit
const appKit = createAppKit({
    adapters: [wagmiAdapter],
    projectId,
    networks: [base, ...networks],
    defaultNetwork: base,
    metadata,
    features: {
        analytics: true,
        email: true,
        socials: ["google", "x", "github", "discord", "farcaster"],
        emailShowWallets: true,
    },
    themeMode: "light",
});

function WalletTracker() {
    const { isConnected, address } = useAccount();
    const [appReady, setAppReady] = useState(false);

    useEffect(() => {
        // Initialize AppKit (returns void, not a client)
        getAppKit(appKit);
        setAppReady(true);
    }, []);

    useEffect(() => {
        if (appReady && isConnected && address) {
            // Access the analytics property via 'appKit' casted as any
            const kit = appKit as any;
            console.log("Wallet connected?", isConnected, address);

            if (kit.analytics && typeof kit.analytics.trackConnection === "function") {
                kit.analytics.trackConnection(address);
            }
        }
    }, [appReady, isConnected, address]);

    return null;
}

interface ContextProviderProps {
    children: ReactNode;
    cookies: string | null;
}

function ContextProvider({ children, cookies }: ContextProviderProps) {
    const initialState = cookieToInitialState(wagmiAdapter.wagmiConfig as Config, cookies);

    return (
        <WagmiProvider config={wagmiAdapter.wagmiConfig as Config} initialState={initialState}>
            <QueryClientProvider client={queryClient}>
                <WalletTracker />
                {children}
            </QueryClientProvider>
        </WagmiProvider>
    );
}

export default ContextProvider;
