// app/content/index.tsx
"use client";

import { wagmiAdapter, projectId, networks } from "@/app/config";
import { createAppKit } from "@reown/appkit/react";
import { base } from "@reown/appkit/networks";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import React, { type ReactNode } from "react";
import { cookieToInitialState, WagmiProvider, type Config } from "wagmi";

const queryClient = new QueryClient();

if (!projectId) {
    throw new Error("NEXT_PUBLIC_PROJECT_ID is not defined");
}

// 👇 Always provide metadata for analytics
const metadata = {
    name: "Idea Sandbox",
    description: "An AI-powered idea generation and brainstorming tool.",
    url: "https://idea-sandbox.vercel.app",
    icons: ["https://idea-sandbox.vercel.app/favicon.ico"],
};

// 👇 Init AppKit modal + analytics
createAppKit({
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

function ContextProvider({
    children,
    cookies,
}: {
    children: ReactNode;
    cookies: string | null;
}) {
    const initialState = cookieToInitialState(
        wagmiAdapter.wagmiConfig as Config,
        cookies
    );

    return (
        <WagmiProvider config={wagmiAdapter.wagmiConfig as Config} initialState={initialState}>
            <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
        </WagmiProvider>
    );
}

export default ContextProvider;
