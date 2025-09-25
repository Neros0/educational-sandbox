"use client";

import { wagmiAdapter, projectId, networks } from "@/app/config";
import { createAppKit } from "@reown/appkit/react";
import { base } from "@reown/appkit/networks";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React, { ReactNode } from "react";
import { cookieToInitialState, WagmiProvider, type Config } from "wagmi";

const queryClient = new QueryClient();

if (!projectId) throw new Error("NEXT_PUBLIC_PROJECT_ID is not defined");

const metadata = {
    name: "Academic Sandbox",
    description: "An AI-powered educational sandbox.",
    url: "https://educational-sandbox.vercel.app",
    icons: ["https://educational-sandbox.vercel.app/favicon.ico"],
};

// Initialize AppKit - this should be done once at module level
createAppKit({
    adapters: [wagmiAdapter],
    projectId,
    networks: [base, ...networks],
    defaultNetwork: base,
    metadata,
    features: {
        analytics: true, // This should be enough for tracking
        email: true,
        socials: ["google", "x", "github", "discord", "farcaster"],
        emailShowWallets: true,
    },
    themeMode: "light",
});

interface ContextProviderProps {
    children: ReactNode;
    cookies: string | null;
}

function ContextProvider({ children, cookies }: ContextProviderProps) {
    const initialState = cookieToInitialState(wagmiAdapter.wagmiConfig as Config, cookies);

    return (
        <WagmiProvider config={wagmiAdapter.wagmiConfig as Config} initialState={initialState}>
            <QueryClientProvider client={queryClient}>
                {children}
            </QueryClientProvider>
        </WagmiProvider>
    );
}

export default ContextProvider;