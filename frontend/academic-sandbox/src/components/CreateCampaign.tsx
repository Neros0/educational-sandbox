// ./src/components/CreateCampaign.tsx
'use client';

import { useState } from 'react';
import { useWriteContract, useWaitForTransactionReceipt, useAccount } from 'wagmi';
import { parseEther } from 'viem';
import { SIMPLE_BRAINSTORM_ADDRESS, SIMPLE_BRAINSTORM_ABI } from '@/config/contract';

export function CreateCampaign() {
    const { address, isConnected } = useAccount();
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    const [fundingGoal, setFundingGoal] = useState('');
    const [durationInDays, setDurationInDays] = useState('');

    const { data: hash, writeContract, isPending, error } = useWriteContract();

    const { isLoading: isConfirming, isSuccess: isConfirmed } = useWaitForTransactionReceipt({
        hash,
    });

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();

        if (!isConnected) {
            alert('Please connect your wallet first');
            return;
        }

        try {
            writeContract({
                address: SIMPLE_BRAINSTORM_ADDRESS,
                abi: SIMPLE_BRAINSTORM_ABI,
                functionName: 'createCampaign',
                args: [
                    title,
                    description,
                    parseEther(fundingGoal),
                    BigInt(durationInDays)
                ],
            });
        } catch (err) {
            console.error('Error creating campaign:', err);
        }
    };

    const resetForm = () => {
        setTitle('');
        setDescription('');
        setFundingGoal('');
        setDurationInDays('');
    };

    if (isConfirmed) {
        setTimeout(() => {
            resetForm();
        }, 3000);
    }

    return (
        <div className="create-campaign-container">
            <form onSubmit={handleSubmit} className="campaign-form">
                <div className="form-group">
                    <label htmlFor="title">Campaign Title</label>
                    <input
                        id="title"
                        type="text"
                        value={title}
                        onChange={(e) => setTitle(e.target.value)}
                        placeholder="Enter campaign title"
                        required
                        disabled={isPending || isConfirming}
                    />
                </div>

                <div className="form-group">
                    <label htmlFor="description">Description</label>
                    <textarea
                        id="description"
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        placeholder="Describe your campaign"
                        rows={4}
                        required
                        disabled={isPending || isConfirming}
                    />
                </div>

                <div className="form-row">
                    <div className="form-group">
                        <label htmlFor="fundingGoal">Funding Goal (ETH)</label>
                        <input
                            id="fundingGoal"
                            type="number"
                            step="0.001"
                            value={fundingGoal}
                            onChange={(e) => setFundingGoal(e.target.value)}
                            placeholder="1.0"
                            required
                            disabled={isPending || isConfirming}
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="duration">Duration (Days)</label>
                        <input
                            id="duration"
                            type="number"
                            value={durationInDays}
                            onChange={(e) => setDurationInDays(e.target.value)}
                            placeholder="30"
                            required
                            disabled={isPending || isConfirming}
                        />
                    </div>
                </div>

                <button
                    type="submit"
                    className="submit-button"
                    disabled={!isConnected || isPending || isConfirming}
                >
                    {isPending ? 'Confirming...' : isConfirming ? 'Creating Campaign...' : 'Create Campaign'}
                </button>

                {hash && (
                    <div className="transaction-status">
                        <p className="tx-hash">Transaction Hash: {hash}</p>
                    </div>
                )}

                {isConfirming && (
                    <div className="status-message status-pending">
                        Waiting for confirmation...
                    </div>
                )}

                {isConfirmed && (
                    <div className="status-message status-success">
                        ✅ Campaign created successfully!
                    </div>
                )}

                {error && (
                    <div className="status-message status-error">
                        Error: {error.message}
                    </div>
                )}
            </form>

            <style jsx>{`
        .create-campaign-container {
          width: 100%;
          max-width: 600px;
        }

        .campaign-form {
          display: flex;
          flex-direction: column;
          gap: 1.5rem;
        }

        .form-group {
          display: flex;
          flex-direction: column;
          gap: 0.5rem;
        }

        .form-group label {
          font-weight: 600;
          color: #333;
          font-size: 0.9rem;
        }

        .form-group input,
        .form-group textarea {
          padding: 0.75rem;
          border: 2px solid #e0e0e0;
          border-radius: 8px;
          font-size: 1rem;
          transition: border-color 0.2s;
        }

        .form-group input:focus,
        .form-group textarea:focus {
          outline: none;
          border-color: #3b82f6;
        }

        .form-group input:disabled,
        .form-group textarea:disabled {
          background-color: #f5f5f5;
          cursor: not-allowed;
        }

        .form-row {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 1rem;
        }

        .submit-button {
          padding: 1rem;
          background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
          color: white;
          border: none;
          border-radius: 8px;
          font-size: 1rem;
          font-weight: 600;
          cursor: pointer;
          transition: transform 0.2s, box-shadow 0.2s;
        }

        .submit-button:hover:not(:disabled) {
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }

        .submit-button:disabled {
          background: #9ca3af;
          cursor: not-allowed;
          transform: none;
        }

        .transaction-status {
          padding: 1rem;
          background: #f3f4f6;
          border-radius: 8px;
        }

        .tx-hash {
          font-size: 0.85rem;
          word-break: break-all;
          color: #6b7280;
        }

        .status-message {
          padding: 1rem;
          border-radius: 8px;
          font-weight: 500;
        }

        .status-pending {
          background: #fef3c7;
          color: #92400e;
        }

        .status-success {
          background: #d1fae5;
          color: #065f46;
        }

        .status-error {
          background: #fee2e2;
          color: #991b1b;
        }

        @media (max-width: 640px) {
          .form-row {
            grid-template-columns: 1fr;
          }
        }
      `}</style>
        </div>
    );
}