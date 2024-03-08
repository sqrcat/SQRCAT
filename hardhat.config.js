/** @type import('hardhat/config').HardhatUserConfig */

require("@nomiclabs/hardhat-waffle");
require("@nomicfoundation/hardhat-verify");

module.exports = {
  solidity: "0.8.20",
  optimizer: {
    enabled: true,
    runs: 200
  },
  networks: {
    fuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      chainId: 43113,
      accounts: ["/*undisclosed in rep*/"],
    },
    mainnet: {
      url: "https://api.avax.network/ext/bc/C/rpc",
      gasPrice: 225000000000,
      chainId: 43114,
      accounts: ["/*undisclosed in rep*/"],
    }
  },
  sourcify: {
    enabled: true
  },
  etherscan: {
    apiKey: {
      avalancheFujiTestnet: 'BLANK',
      avalanche: '/*undisclosed in rep*/'
    }
  }  
};
