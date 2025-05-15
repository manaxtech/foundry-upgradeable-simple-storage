-include .env

all:; clean remove install update build

clean:; @forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install:; forge install Openzeppelin/openzeppelin-contracts --no-commit && forge install Openzeppelin/openzeppelin-contracts-upgradeable --no-commit && forge install cyfrin/foundry-devops --no-commit

# update dependencies
update:; forge update

build:; @forge build

script_deploy := forge script script/Deploy.s.sol
script_Interaction := forge script script/Interactions.s.sol

key := anvil_key_1
address := $(ANVIL_ADDRESS_1)

network_account_args := --rpc-url $(ANVIL_RPC_URL) --account $(key) --broadcast
network_sender_args := --rpc-url $(ANVIL_RPC_URL) --sender $(address) --broadcast

# for the key use keystore encrypted private key called test_key_1 (cast wallet import test_key_1 --interactive)
ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	key := test_key_1
	address := $(TEST_ADDRESS_1)
	network_account_args := --rpc-url $(SEPOLIA_RPC_URL) --account $(key) --broadcast --verify --etherscan--api-key $(ETHERSCAN_API_KEY)
	network_sender_args := --rpc-url $(SEPOLIA_RPC_URL) --sender $(address) --broadcast --verify --etherscan--api-key $(ETHERSCAN_API_KEY)
endif

deploySS:; $(script_deploy):DeploySimpleStorage $(network_account_args)
deployAFS:; $(script_deploy):DeployAddFiveStorage $(network_account_args)
deploySF:; $(script_deploy):DeployStorageFactory $(network_account_args)
deploySP:; $(script_deploy):DeploySmallProxy $(network_account_args)
deployT:; $(script_deploy):DeployTarget $(network_account_args)
deployPT:; $(script_deploy):DeployProxyT $(network_account_args)

deploySSUT:; $(script_deploy):DeploySimpleUpgradeableTemplate $(network_account_args)
deployAFSUT:; $(script_deploy):DeployAddFiveUpgradeableTemplate $(network_account_args)
deployUS:; $(script_deploy):DeployUpgradeableStorage $(network_account_args)
upgradeUS:; $(script_deploy):UpgradeUpgradeableStorage $(network_account_args)


# simple storage

storeSS:; $(script_Interaction):StoreSimpleStorage $(network_account_args)

euclidGCFSS:; $(script_Interaction):EuclidGCFSimpleStorage $(network_sender_args)

retrieveSS:; $(script_Interaction):RetrieveSimpleStorage $(network_sender_args)

addPersonSS:; $(script_Interaction):AddPersonSimpleStorage $(network_account_args)

getPersonSS:; $(script_Interaction):GetPersonSimpleStorage $(network_sender_args)

getPersonStructSS:; $(script_Interaction):GetPersonStructSimpleStorage $(network_sender_args)

getPeopleStructSS:; $(script_Interaction):GetPeopleStructSimpleStorage $(network_sender_args)

# add five storage

storeAFS:; $(script_Interaction):StoreAddFiveStorage $(network_account_args)

retrieveAFS:; $(script_Interaction):RetrieveAddFiveStorage $(network_sender_args)

# Delegate

deployT:; $(script_deploy):DeployTarget $(network_account_args)

deployPT:; $(script_deploy):DeployProxyT $(network_account_args)

setProxy:; $(script_Interaction):SetProxyT $(network_account_args)

callAnyFunction:; $(script_Interaction):CallAnyFunctionProxyT $(network_account_args)

getProxy:; $(script_Interaction):ValueSenderMoney1Money2SomeDataProxyT $(network_sender_args)

# Small proxy

setImSP:; $(script_Interaction):SetImplementationSmallProxy $(network_account_args)

storeSSP:; $(script_Interaction):StoreSimpleStorageSmallProxy $(network_account_args)

storeSAFSP:; $(script_Interaction):StoreAddFiveStorageSmallProxy $(network_account_args)

retrieveSSP:; $(script_Interaction):RetrieveSimpleStorageSmallProxy $(network_sender_args)

retrieveAFSP:; $(script_Interaction):RetrieveAddFiveStorageSmallProxy $(network_sender_args)

read0SP:; $(script_Interaction):ReadStorageSlotZeroSmallProxy $(network_sender_args)

read1SP:; $(script_Interaction):ReadStorageSlotOneSmallProxy $(network_sender_args)

read2SP:; $(script_Interaction):ReadStorageSlotTwoSmallProxy $(network_sender_args)

addPersonSSP:; $(script_Interaction):AddPersonSimpleStorageSmallProxy $(network_account_args)

