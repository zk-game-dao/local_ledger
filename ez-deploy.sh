#!/bin/bash

# Example usage:
# ./ez-deploy.sh --principals principalA principalB principalC --account-ids accountA accountB accountC

dfx identity use minter
export MINTER_PRINCIPAL=$(dfx identity get-principal)
export MINTER_ACCOUNT_ID=$(dfx ledger account-id)
export MINTER_ACCOUNT="record { owner = principal \"$MINTER_PRINCIPAL\"; subaccount = null }"

dfx identity use default
export DEFAULT_ACCOUNT_ID=$(dfx ledger account-id)

# Define Decideai DAO principal
export DECIDEAI_PRINCIPAL="xsi2v-cyaaa-aaaaq-aabfq-cai"
export DECIDEAI_ACCOUNT="record { owner = principal \"$DECIDEAI_PRINCIPAL\"; subaccount = null }"

# Get the arguments passed to the script
args=("$@")

# Create an empty array to store the account records
icp_records=()
ckusdc_records=()
ckusdt_records=()
cketh_records=()
ckbtc_records=()
dcd_records=()

# Add Decideai DAO to DCD token records
dcd_records+="
  record {
    $DECIDEAI_ACCOUNT;
    1000_000_000_000 : nat;
  };"

# Loop through the arguments
currentParamTest=""
for arg in "${args[@]}"; do
 if [[ $arg == "--account-ids" ]]; then
   currentParamTest="accountIds"
   continue
 fi
 if [[ $arg == "--principals" ]]; then
   currentParamTest="principals"
   continue
 fi
 
 if [[ $currentParamTest == "accountIds" ]]; then
   icp_records+="
     record {
       \"$arg\";
       record {
         e8s = 1000_000_000_000 : nat64;
       };
     };"
 fi
 
 if [[ $currentParamTest == "principals" ]]; then
   account="record { owner = principal \"$arg\"; subaccount = null }"
   ckusdc_records+="
     record {
       $account;
       1000_000_000_000 : nat;
     };"
    ckusdt_records+="
      record {
        $account;
        1000_000_000_000 : nat;
      };"
    cketh_records+="
      record {
        $account;
        1000_000_000_000 : nat;
      };"
    ckbtc_records+="
      record {
        $account;
        1000_000_000_000 : nat;
      };"
    dcd_records+="
      record {
        $account;
        1000_000_000_000 : nat;
      };"
 fi
done

echo "ICP Records: ${icp_records[@]}"
echo "CKUSDC Records: ${ckusdc_records[@]}"
echo "CKUSDT Records: ${ckusdt_records[@]}"
echo "CKETH Records: ${cketh_records[@]}"
echo "CKBTC Records: ${ckbtc_records[@]}"
echo "DCD Records: ${dcd_records[@]}"

# Deploy the canister

dfx deploy --specified-id ryjl3-tyaaa-aaaaa-aaaba-cai icp_ledger_canister --argument "
  (variant {
    Init = record {
      minting_account = \"$MINTER_ACCOUNT_ID\";
      initial_values = vec {
        $icp_records
      };
      send_whitelist = vec {};
      transfer_fee = opt record {
        e8s = 10_000 : nat64;
      };
      token_symbol = opt \"LICP\";
      token_name = opt \"Local ICP\";
    }
  })"

dfx deploy --specified-id xevnm-gaaaa-aaaar-qafnq-cai ckusdc_ledger_canister --argument "
  (variant {
    Init = record {
      minting_account = $MINTER_ACCOUNT;
      initial_balances = vec {
        $ckusdc_records
      };
      transfer_fee = 10_000 : nat;
      token_symbol = \"LCKUSDC\";
      token_name = \"Local CKUSDC\";
      metadata = vec {};
      fee_collector_account = null;
      decimals = opt (6 : nat8);
      max_memo_length = null;
      feature_flags = null;
      maximum_number_of_accounts = null;
      accounts_overflow_trim_quantity = null;
      archive_options = record {
        num_blocks_to_archive = 2000 : nat64;
        max_transactions_per_response = null;
        trigger_threshold = 2000 : nat64;
        max_message_size_bytes = null;
        cycles_for_archive_creation = null;
        node_max_memory_size_bytes = null;
        controller_id = principal \"$(dfx identity get-principal)\";
        more_controller_ids = null;
      };
    }
  })"

dfx deploy --specified-id cngnf-vqaaa-aaaar-qag4q-cai ckusdt_ledger_canister --argument "
  (variant {
    Init = record {
      minting_account = $MINTER_ACCOUNT;
      initial_balances = vec {
        $ckusdt_records
      };
      transfer_fee = 10_000 : nat;
      token_symbol = \"LCKUSDT\";
      token_name = \"Local CKUSDT\";
      metadata = vec {};
      fee_collector_account = null;
      decimals = opt (6 : nat8);
      max_memo_length = null;
      feature_flags = null;
      maximum_number_of_accounts = null;
      accounts_overflow_trim_quantity = null;
      archive_options = record {
        num_blocks_to_archive = 2000 : nat64;
        max_transactions_per_response = null;
        trigger_threshold = 2000 : nat64;
        max_message_size_bytes = null;
        cycles_for_archive_creation = null;
        node_max_memory_size_bytes = null;
        controller_id = principal \"$(dfx identity get-principal)\";
        more_controller_ids = null;
      };
    }
  })"

dfx deploy --specified-id ss2fx-dyaaa-aaaar-qacoq-cai cketh_ledger_canister --argument "
  (variant {
    Init = record {
      minting_account = $MINTER_ACCOUNT;
      initial_balances = vec {
        $cketh_records
      };
      transfer_fee = 10_000 : nat;
      token_symbol = \"LCKETH\";
      token_name = \"Local CKETH\";
      metadata = vec {};
      fee_collector_account = null;
      decimals = opt (18 : nat8);
      max_memo_length = null;
      feature_flags = null;
      maximum_number_of_accounts = null;
      accounts_overflow_trim_quantity = null;
      archive_options = record {
        num_blocks_to_archive = 2000 : nat64;
        max_transactions_per_response = null;
        trigger_threshold = 2000 : nat64;
        max_message_size_bytes = null;
        cycles_for_archive_creation = null;
        node_max_memory_size_bytes = null;
        controller_id = principal \"$(dfx identity get-principal)\";
        more_controller_ids = null;
      };
    }
  })"

dfx deploy --specified-id xsi2v-cyaaa-aaaaq-aabfq-cai dcd_ledger_canister --argument "
  (variant {
    Init = record {
      minting_account = $MINTER_ACCOUNT;
      initial_balances = vec {
        $dcd_records
      };
      transfer_fee = 10_000 : nat;
      token_symbol = \"DCD\";
      token_name = \"Decideai Token\";
      metadata = vec {
        record {
          \"icrc1:logo\";
          variant {
            Text = \"data:image/png;base64,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\"
          };
        };
        record { \"icrc1:decimals\"; variant { Nat = 8 : nat } };
        record { \"icrc1:name\"; variant { Text = \"DecideAI\" } };
        record { \"icrc1:symbol\"; variant { Text = \"DCD\" } };
        record { \"icrc1:fee\"; variant { Nat = 10_000 : nat } };
        record { \"icrc1:max_memo_length\"; variant { Nat = 32 : nat } };
      };
      fee_collector_account = null;
      decimals = opt (6 : nat8);
      max_memo_length = null;
      feature_flags = null;
      maximum_number_of_accounts = null;
      accounts_overflow_trim_quantity = null;
      archive_options = record {
        num_blocks_to_archive = 2000 : nat64;
        max_transactions_per_response = null;
        trigger_threshold = 2000 : nat64;
        max_message_size_bytes = null;
        cycles_for_archive_creation = null;
        node_max_memory_size_bytes = null;
        controller_id = principal \"$(dfx identity get-principal)\";
        more_controller_ids = null;
      };
    }
  })"