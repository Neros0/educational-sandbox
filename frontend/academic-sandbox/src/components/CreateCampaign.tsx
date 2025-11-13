// ./src/components/CreateCampaign.tsx
'use client';

import { useState } from 'react';
import { useWriteContract, useWaitForTransactionReceipt, useAccount } from 'wagmi';
import { parseEther } from 'viem';
import { SIMPLE_BRAINSTORM_ADDRESS, SIMPLE_BRAINSTORM_ABI } from '@/config/contract';

export function CreateCampaign() {
    const { isConnected } = useAccount();
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


        </div>
    );
}