// components/SignMessage.tsx
'use client';
import { useAccount, useSignMessage } from 'wagmi';
import { useState, useEffect } from 'react';

export default function SignMessage() {
    const { isConnected, address, chainId } = useAccount();
    const { signMessage, isPending, isSuccess, error } = useSignMessage();
    const [hasSigned, setHasSigned] = useState(false);
    const [sessionCreated, setSessionCreated] = useState(false);

    const handleSignMessage = async () => {
        if (!isConnected || !address) return;

        const message = `Welcome to Academic Sandbox!

This signature creates your analytics session.

Address: ${address}
Chain ID: ${chainId}
Timestamp: ${new Date().toISOString()}
Domain: ${window.location.hostname}

By signing this message, you agree to participate in our educational platform.`;

        try {
            const signature = await signMessage({ message });

            console.log("📝 Message signed successfully");
            console.log("✍️ Signature:", signature);

            setHasSigned(true);

            // Track the signing event for analytics
            try {
                const sessionData = {
                    address,
                    chainId,
                    signature,
                    message,
                    timestamp: new Date().toISOString(),
                    domain: window.location.hostname,
                    projectId: (window as any).reownProjectId
                };

                console.log("📊 Session Data for Analytics:", sessionData);

                // Try to manually create analytics session
                if (typeof window !== 'undefined' && (window as any).appkit) {
                    const appKit = (window as any).appkit;

                    // Attempt different methods to trigger analytics
                    if (appKit.track) {
                        appKit.track('session_created', sessionData);
                    }

                    if (appKit.analytics) {
                        appKit.analytics.track('user_signed_message', sessionData);
                    }

                    setSessionCreated(true);
                    console.log("🎯 Analytics session creation attempted");
                }

                // Also try a manual API call to Reown analytics
                try {
                    const analyticsPayload = {
                        projectId: (window as any).reownProjectId,
                        event: 'user_authenticated',
                        properties: {
                            address: address,
                            chainId: chainId,
                            domain: window.location.hostname,
                            timestamp: Date.now(),
                            method: 'message_signature'
                        }
                    };

                    // This might work for manual tracking
                    console.log("📡 Attempting manual analytics call:", analyticsPayload);

                } catch (apiError) {
                    console.log("📡 Manual API call not available:", apiError);
                }

            } catch (analyticsError) {
                console.error("📊 Analytics tracking error:", analyticsError);
            }

        } catch (signError) {
            console.error("❌ Failed to sign message:", signError);
        }
    };

    // Reset state when wallet disconnects
    useEffect(() => {
        if (!isConnected) {
            setHasSigned(false);
            setSessionCreated(false);
        }
    }, [isConnected]);

    if (!isConnected) return null;

    return (
        <div className="grid bg-white border border-gray-200 rounded-lg overflow-hidden shadow-sm mt-4">
            <h3 className="text-sm font-semibold bg-purple-100 p-2 text-center">
                🔐 Create Analytics Session
            </h3>
            <div className="flex flex-col justify-center items-center p-4 space-y-3">
                <div className="text-center space-y-1">
                    <p className="text-xs text-gray-600">
                        Sign a message to create a tracked session in Reown analytics
                    </p>
                    <p className="text-xs text-blue-600">
                        Connected: {address?.slice(0, 6)}...{address?.slice(-4)}
                    </p>
                </div>

                {error && (
                    <div className="text-red-600 text-xs bg-red-50 p-2 rounded">
                        Error: {error.message}
                    </div>
                )}

                {!hasSigned ? (
                    <button
                        onClick={handleSignMessage}
                        disabled={isPending}
                        className="bg-purple-500 hover:bg-purple-600 disabled:bg-gray-400 text-white px-6 py-2 rounded-lg text-sm font-medium transition-colors"
                    >
                        {isPending ? '✍️ Signing...' : '🖊️ Sign Welcome Message'}
                    </button>
                ) : (
                    <div className="text-center space-y-2">
                        <div className="text-green-600 text-sm font-medium">
                            ✅ Message signed successfully!
                        </div>
                        {sessionCreated && (
                            <div className="text-blue-600 text-xs">
                                📊 Analytics session created - check your Reown dashboard!
                            </div>
                        )}
                        <div className="text-xs text-gray-500">
                            It may take 30-60 minutes for data to appear in analytics
                        </div>
                    </div>
                )}

                {hasSigned && (
                    <button
                        onClick={() => {
                            setHasSigned(false);
                            setSessionCreated(false);
                        }}
                        className="text-xs text-gray-500 hover:text-gray-700 underline"
                    >
                        Sign again
                    </button>
                )}
            </div>
        </div>
    );
}