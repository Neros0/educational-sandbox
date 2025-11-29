import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  webpack: config => {
    config.externals.push(
      'pino-pretty', 
      'lokijs', 
      'encoding', 
      'porto',
      '@coinbase/wallet-sdk',
      '@gemini-wallet/core',
      '@metamask/sdk',
      '@walletconnect/ethereum-provider'
    );
    
    // Add fallbacks for Node.js modules
    config.resolve.fallback = {
      ...config.resolve.fallback,
      fs: false,
      net: false,
      tls: false,
      crypto: false,
    };
    
    // Ignore React Native modules in browser environment
    config.resolve.alias = {
      ...config.resolve.alias,
      '@react-native-async-storage/async-storage': false,
      'react-native': false,
    };
    
    return config;
  }
};

export default nextConfig;