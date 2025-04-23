
flowchart TD
    A[Login (Google/Facebook/Email)] --> B{User Role}
    B --> C[Parent Dashboard]
    B --> D[Child Dashboard]

    C --> E[Assign Chore]
    C --> F[View Child Tasks & Proof Images]

    D --> G[View Chores]
    G --> H[Receive Reminder]
    H --> I{User Action}
    I -->|Complete| J[Upload Image Proof]
    I -->|Delay| K[Set Later Reminder]

    J --> L[Parent Reviews]
    L -->|Approve| M[Reward Given (Money/Time/Points)]
    L -->|Reject| G
    
