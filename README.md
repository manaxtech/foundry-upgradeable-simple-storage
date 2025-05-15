# UPGRADEABLE STORAGE

A comprehensive demonstration of Solidity patterns including storage management, inheritance, UUPS upgrades, delegate calls, and proxy implementations. Built with Foundry.


## Core Contracts

### 1. Storage Contracts

#### SimpleStorage
- Stores numbers and person structs (name + favorite number)
- Features:
  - `store()` and `addPerson()` function for storing name and favoriteNumber
  - Multiple getter patterns
  - Euclidean algorithm utility

#### AddFiveStorage (inherits SimpleStorage)
- Overrides `store()` to add 5 to all inputs
- Maintains all parent functionality

### 2. Upgradeable Implementations

#### UUPSUSimpleStorage (inherits simpleStorage)
- UUPS upgradeable version
- Initializes with value 3 to be stored in `myFavoriteNumber`
- Ownable upgrade authorization

#### UUPSUAddFiveStorage (inherits AddFiveStorage)
- UUPS upgradeable +5 version
- Reinitializable (version 2) with value 5 (+5 effect)

### 3. Proxy & Delegate Call Systems

#### DelegateUpgradeable
**Demonstrates:**
- Target contract with multiple storage variables
- Proxy contract using delegatecall to:
  - Modify storage in context of proxy
  - Preserve msg.sender and msg.value
- Dynamic function calling with:
  - `abi.encodeWithSignature`
  - Raw function selector calculation

**Key Features:**
- Shows storage slot preservation
- Error handling for failed calls
- Payable function delegation

#### SmallProxy
**Minimal Upgradeable Proxy:**
- Implements EIP-1967 storage slot
- Assembly-level implementation:
  - `sstore`/`sload` for implementation address
  - Storage slot inspection methods
- Features:
  - `setImplementation()` for upgrades
  - Storage inspection functions
  - Data encoding helper

## Key Patterns Demonstrated

1. **Delegate Call Pattern**
   - Execute logic in target contract's context
   - Preserves proxy's storage layout
   - Shows msg.sender/value preservation

2. **Proxy Upgrade Pattern**
   - EIP-1967 implementation slot
   - Storage slot collision prevention
   - Minimal proxy implementation

3. **UUPS Upgrade Pattern**
   - Gas-efficient upgrades
   - Upgrade authorization via ownership
   - Versioned initialization

## Quick Start

```bash
make all  # Installs dependencies, compiles, and runs tests
```