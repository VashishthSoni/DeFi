Here are the all swap contract for UniswapV2 swap exact tokens for tokens.<br>
To test this contracts Create <a href="https://book.getfoundry.sh/projects/creating-a-new-project">Foundry</a> project and add <b> contract file in src directory and test(.t.sol) files in test directory</b>.<br>
<br>
Then run following commands:<hr>
  <b>FORK_URL=YOUR_WEB3_PROVIDER'S_API_KEY</b>
  <b>forge test -vv --gas-report --fork-url $FORK_URL --match-path test/testFileName</b>
  <hr>
  <br>
  In FORK_URL use web3 provider's API key for mannet fork like <a href="https://www.alchemy.com/homepage">alchemy</a>, <a href="https://www.infura.io/">Infura</a>, etc.
  <br>
  Mainnet fork is usefull to test contract in current blockchain state.
