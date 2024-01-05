# PANTOS PANDAS THIRDWEB scripts

![version](https://img.shields.io/badge/version-1.0.0-blue)

This package includes example contracts using the THIRDWEB extentsions as well as scripts to deploy, register und unregister PANDAS tokens not created with the Pantos Tokencreator. These scripts can be used for any PANDAS token you are a registered owner.

## Step 1: Prerequisites
  * _python_ (version `3.6 or later`) including _package installer for python (pip)_
  * _brownie_
  * added _private keys_ to brownie
  * insure that the testnetworks Holesky, BNB, Fuji, Mumbai, Cronos, Fantom and Alfajores are included in your _network-config.yaml_ (example file encluded)
  * insure that the explorers for Holesky, BNB, Fuji, Mumbai, Cronos, Fantom and Alfajores are included in your _network-config.yaml_ (example file encluded) which are required for automatic contract verification
  * API keys for each explorer for contract verification to be srt in the .env file (example .env included)
  * enough _Test coins_ on each chain for gas
  * _1.000 PAN_ per chain in case you wish to deploy/register tokens with the Pantos Hub

  For detailed instructions, please also check the step-by-step instructions of @kurzi2704 https://github.com/kurzi2704/pantos-pandas-creator/tree/main



## Step 2: Add OpenZeppelin dependencies to brownie-config.yaml
Add the following lines to your brownie-config.yaml file in order to be able to download the OpenZeppelin and ThirdWeb dependencies as well as to allow working with environment variables:


### Step 2.1: Install dependencies
```shell 
  brownie pm install OpenZeppelin/openzeppelin-contracts@4.1.0
  brownie pm install thirdweb-dev/contracts@3.11.0
```

### Step 2.2: Adjust brownie-config.yaml
```shell 
compiler:
    solc:
        version: 0.8.17
        remappings:
            - "@openzeppelin=OpenZeppelin/openzeppelin-contracts@4.1.0"
            - "@thirdweb=thirdweb-dev/contracts@3.11.0"
dependencies:
  - OpenZeppelin/openzeppelin-contracts@4.1.0
  - thirdweb-dev/contracts@3.11.0

# enable output of development artifacts to load with react
dev_deployment_artifacts: true

dotenv: .env    # enviroment variables
```

## Step 3. Deploy PANDAS tokens
### Step 3.1 Adjust PANDASTOKEN.sol in /contracts folder

You don't need to set `_NAME` `_SYMBOL` `_DECIMALS` or `INITIALSUPPLY` for your token in the solidity contract itself. These parameters will be set by the deployment script. 

The example token uses a very minimum of ThirdWebs extensions (IPFS extension)

### Step 3.2 Adjust deploy_PANDAS.py in /scripts folder

The following variables need to be adjusted:

```python
...
NAME = "THIRDWEB EXAMPLE TOKEN (PANDAS)"
SYMBOL = "TWET"
DECIMALS = 18
INITIAL_SUPPLY = 100 * 10 ** DECIMALS
PRIORITY_FEE = '50 gwei' 
...
```

You need to copy/paste the network names of the Pantos compatible chains from your `_network-config.yaml_` in the MYNETWORKS directory (line 33ff)
Please do not change the index keys, since these are fixed assigned by Pantos as ChainIDs. If you just want to deploy to a specific chain, just delete the chains not required in MYNETWORKS.

```python
...
MYNETWORKS = {

    0: "holesky",           # ETHEREUM Holesky        
    1: "bnb-test",          # BNB Chain             
    3: "avax-test",         # AVALANCHE Fuji        
    5: "polygon-test",      # POLYGON MUMBAI        
    6: "cronos-test",       # CRONOS                
    7: "fantom-test",       # FANTOM                
    8: "celo-test"          # CELO ALFAJORES        
    }
...
```
### Step 3.3 Deploy

```shell 
brownie run ./scripts/deploy_PANDAS.py main <account> 
```

with <account> being one of the accounts in the brownie accounts list 
```shell 
brownie accounts list 
```

You will be asked for a password and the script will deploy the token on each chain defined in the `MYNETWORKS` directory.
The entire deploy process includes:
* mint of the token on each chain
* approve of PAN tokens for the PantosHub on each chain
* registration of the token with the PantosHub on each chain including PAN stake (1.000 PAN per chain and token)
* setPantosForwarder on each chain
* external registrations on each chain

After the script is finished your tokens are fully PANDAS enabled and can be used for multichain transfers immediately.

The contract addresses of your tokens will be saved in a 'myTokens.txt' file

### Step 4 Import to Thirdweb

Upon deployment and verification, you can import your tokencontracts in thirdweb -> https://thirdweb.com/dashboard/contracts/deploy
