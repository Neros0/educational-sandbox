// ./src/config/contract.ts
export const SIMPLE_BRAINSTORM_ADDRESS = '0x4429f4544Ed4D7E4893DdB97f35a878aDaEDed8F' as const;

export const SIMPLE_BRAINSTORM_ABI = [
  {
    type: 'function',
    name: 'createCampaign',
    stateMutability: 'nonpayable',
    inputs: [
      { name: '_title', type: 'string' },
      { name: '_description', type: 'string' },
      { name: '_fundingGoal', type: 'uint256' },
      { name: '_durationInDays', type: 'uint256' }
    ],
    outputs: [{ name: '', type: 'uint256' }]
  },
  {
    type: 'function',
    name: 'getCampaignInfo',
    stateMutability: 'view',
    inputs: [{ name: '_campaignId', type: 'uint256' }],
    outputs: [
      { name: 'creator', type: 'address' },
      { name: 'title', type: 'string' },
      { name: 'description', type: 'string' },
      { name: 'fundingGoal', type: 'uint256' },
      { name: 'deadline', type: 'uint256' },
      { name: 'isActive', type: 'bool' }
    ]
  },
  {
    type: 'function',
    name: 'campaignCount',
    stateMutability: 'view',
    inputs: [],
    outputs: [{ name: '', type: 'uint256' }]
  },
  {
    type: 'event',
    name: 'CampaignCreated',
    inputs: [
      { name: 'campaignId', type: 'uint256', indexed: true },
      { name: 'creator', type: 'address', indexed: true },
      { name: 'title', type: 'string', indexed: false },
      { name: 'fundingGoal', type: 'uint256', indexed: false },
      { name: 'deadline', type: 'uint256', indexed: false }
    ]
  }
] as const;