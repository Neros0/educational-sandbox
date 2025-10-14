'use client'

import { useState } from 'react'
import { useSignMessage, useAccount } from 'wagmi'
import { useClientMounted } from "@/hooks/useClientMount"

export const SignMessage = () => {
    const mounted = useClientMounted()
    const { isConnected } = useAccount()
    const [message, setMessage] = useState('')
    const [lastSignature, setLastSignature] = useState<string>('')

    const { signMessage, isPending, isSuccess, error } = useSignMessage({
        mutation: {
            onSuccess: (signature) => {
                setLastSignature(signature)
                console.log('Signature:', signature)
            },
            onError: (error) => {
                console.error('Signing error:', error)
            }
        }
    })

    const handleSign = async () => {
        if (!message.trim()) {
            alert('Please enter a message to sign')
            return
        }

        signMessage({ message })
    }

    const handleCopySignature = () => {
        if (lastSignature) {
            navigator.clipboard.writeText(lastSignature)
            alert('Signature copied to clipboard!')
        }
    }

    if (!mounted) return null

    if (!isConnected) {
        return (
            <div className="sign-message-container">
                <h2>Sign Message</h2>
                <p className="info-text">Connect your wallet to sign messages</p>
            </div>
        )
    }

    return (
        <div className="sign-message-container">
            <h2>Sign Message</h2>

            <div className="input-group">
                <label htmlFor="message-input">Message to Sign:</label>
                <textarea
                    id="message-input"
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    placeholder="Enter your message here..."
                    rows={4}
                    disabled={isPending}
                />
            </div>

            <button
                onClick={handleSign}
                disabled={isPending || !message.trim()}
                className="sign-button"
            >
                {isPending ? 'Signing...' : 'Sign Message'}
            </button>

            {error && (
                <div className="error-message">
                    <strong>Error:</strong> {error.message}
                </div>
            )}

            {isSuccess && lastSignature && (
                <div className="signature-result">
                    <h3>Signature:</h3>
                    <div className="signature-box">
                        <code>{lastSignature}</code>
                    </div>
                    <button onClick={handleCopySignature} className="copy-button">
                        Copy Signature
                    </button>
                </div>
            )}
        </div>
    )
}