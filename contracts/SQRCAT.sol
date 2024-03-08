// SPDX-License-Identifier: MIT
// ---                    
// The Order of the Square [ ] 
//
/***************************************************************************
 
                                                                        @@@@    
         @/@                                                       @@@,//&@     
        @,,@@                                                  @@%,,@@//@@      
       @,°//@@                                              @@/,,&@@///@%       
      @%,,,,*@@                                          @@°///,@@@@//@@        
     &@,,,////@@                                      @@////,,,,,@@///@         
     @,,,/°,,,*%@@                                  @@,,,°//,,,,@////@@         
    @,,,,,,,/////@@.       .@@@@@@@@@@@@@@.       @(////,,,,,,,@#////@          
   @@,,,,,,/////,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@///,,,,,,*@@@///@          
   @,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@,,,,,,,,,,,,,,,,,,,,,@@////@          
  @@,,,,,,,,,,,,,,,,,,,,*@@%,,,,@          %@,,,,,,,,,,,,,,,,,,@@////@@         
  @,,,,,,,,,,,,,,,,,,*@       @@    @@@      @,,,,,,,,,,,,,,,,,,,@@///@#        
 @@,,,,,,,,,,,,,,,,,,@     @, @@     ,       @,,,,,,,,,,,,,,,,,,,,,,,/@@        
 @@,,,,,,,,,,,,,,,,,,,@      @,,@&          @,,,,,,,,,,,,,,,/@@@@,,,,,/@/       
 @,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,&@@@%@@@,,,,,,,,,,,,...,@@.   @@,,,/@@       
 @,,,,,,,,,,,,,,,,,  .,,,,@@@@@@@@@@@@@,,,. ,,,,,,,,,,,,,,*@@     @@,,,/@@      
 @,,,,,,,,,,,,,,,,,,,,,,,/@@@@@@@@@@@@@@,              ,,,/@.   @@@@,,,/%@      
 @,,,,,,,,  ,,,,,,,,,,,,,,,@@@@@@@@@@@(,,,,,,,,,,,,,,,,,,*@@  @@  @*,,,,/@@     
 @/, ,,,,,,,,,,,,,,,,,,,, ,,,@@@@@@@@,,,,,,,,,,,,,,,,,, *@@@#    @#,,,,,,/@     
 @@,,,,,,,,,,,,,,,,,, ,,,,,,,,,,@@,,,,,,,,,,,,,,,,,,,,/@@@    /@@,,,,,,,,/@@    
 (@,,,,@%,,,,,,,,,,,,,,,,,,,,,,,@/@@,,,,,,,,,,,,,,/@@@@    @@@@,,,,,,,/,,,/@    
  @@,,,,,&@@,,,,,,,,,,,,,,,,,&@@/,,//@@@@@@@@@@@   @   #@ @@*,,,,,,,//,,,,//@   
   @@,,,,,,,°///#&@@@@@@@@(//°,,,,,,,,,,,,,,,,,,,,,&@@@/,,,,,,,,@@(/////////@   
     @@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(/,,,,@#@@@@@@@#           
       (@@@,,,,,,,,,,,,,,,,,,,°/(&@@@@,,,,@@@@°°°°°°°°°°°°°°°°°°°°°
                                  @@@@,,,,@@@@
                                  @@@@,,,/@@@@
                                 @@@@@,,/(@@@@@@
                               @@@@@@@,,,/@@@#///%@@@@@
                              @@@@@@@/,,,#°///////////@@@
                              @@@@,,,,,,,,,,,,,,//@////@@@
                              @@,,,,(*,,,,,,,,,,,//@///%@@@
                              @@,,,,@,,,,,,,,,,,,,//@///@@@
                              @@,,,@#,,,,,,,,,,,,,°//@///@@
                              @@,,,@,,,,,,,,,,,,,,,//@///@@
                              @@,,,@,,,,,,,,,,,,,,,,/(@//@@
                              @@,,,@#,,,,,,,,,,,*°/////@//@@
                              @@,,,,@,,,,,,,,,,,,,,,,///&@/@@
                              @@(,,@,,,,,,,,,,,,,,,,,,////@/@@                 
                              @@@,@,,,,,,,,,,,,,,,,,,,,////@@@                 
                               @@@@,,,,,,,,,,,,,,,,,,,,°////@@@                 
                                @@,,,,,,,,,,,,,,,,,,,,,,////@@@     

*****************************************************************************/

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC721.sol";

contract SQRCAT is ERC20, Ownable(msg.sender) {

    // Strain 'em out ...
    bool public whaleStrainer = true;

    uint8 public whitelistPhase = 0;

    mapping (address => bool) public whitelistPhase1;
    mapping (address => bool) public whitelistPhase2;

    address public liquidityPool;

    constructor() ERC20("SQRCAT", "SQRCAT") {
        _mint(msg.sender, 48163264128256 * 10 ** 18);
    }

    function setWhaleStrainer(bool _state) external onlyOwner {
        whaleStrainer=_state;
    }

    function getWhaleStrainer() external view returns (bool) {
        return whaleStrainer;
    }

    function setLiquidityPool(address _liquidityPool) external onlyOwner {
        liquidityPool=_liquidityPool;
    }

    function getLiquidityPool() external view returns (address) {
        return liquidityPool;
    }

    function setWhitelistPhase(uint8 _phase) external onlyOwner {
        if(_phase < whitelistPhase) require(false, "Cat's pride: only forward, never back!"); // It's a matter of trust!
        whitelistPhase=_phase;
    }

    function getWhitelistPhase() external view returns (uint8) {
        return whitelistPhase;
    }

    function addWalletsToWhitelistPhase1(address[] memory walletAddresses) external onlyOwner {
        for (uint256 i = 0; i < walletAddresses.length; i++) {
            whitelistPhase1[walletAddresses[i]]=true;
        }
    }

    function addWalletsToWhitelistPhase2(address[] memory walletAddresses) external onlyOwner {
        for (uint256 i = 0; i < walletAddresses.length; i++) {
            whitelistPhase2[walletAddresses[i]]=true;
        }
    }

    // Cat sniffin' in realtime to check NFT ownership
    function walletIsNFTOwner(address _wallet, address _contract) public view returns (bool) {
        return IERC721(_contract).balanceOf(_wallet) > 0;
    }
    
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {

        super._update(from, to, amount);

        if(address(0) == liquidityPool) {
            require(from == owner() || to == owner(), "No liquidity - no cat!");
            return;
        }

        if(to != liquidityPool) {
            if(whitelistPhase == 0) {
                require(false, "Still sleepin' in the litterbox. Go do some kneading ...");
                /*
                      |\      _,,,---,,_
                ZZZzz /,`.-'`'    -.  ;-;;,_
                     |,4-  ) )-,_. ,\ (  `'-'
                    '---''(_/--'  `-'\_)  
                */
            } else if(whitelistPhase == 1) {
                require(whitelistPhase1[to], "Whitelist phase 1 for LP donors and promotional partners!");
            } else if(whitelistPhase == 2) {
                require(whitelistPhase2[to] ||
                    walletIsNFTOwner(to, 0x5bEb759F7769193a8e401bb2d7CaD22bACb930d5) || /* SMOL JOES, TRADER JOE 4 PRESIDENT */
                    walletIsNFTOwner(to, 0x0c3546ecfcA3979dFD66FD4452C3a06466fA19f0) || /* SHOE404, TOO SMALL TO WEAR, TOO COOL TO BEAR. AL BUNDY STYLE! */
                    walletIsNFTOwner(to, 0x4D2fA52D6F08034EE98A4C6C81a5eAde726c8354),   /* FOR OUR FRACTIO OG'S, WE'VE BEEN THERE, WE KNOW YOUR PAIN */
                    "Need to be whitelisted in phase 2 or be an NFT holder of either Shoe404, SMOL Joes or Fractio Finance!");
            }
        }

        if (to != liquidityPool && from != owner() && whaleStrainer) {
            require(
                balanceOf(to) <= (totalSupply() / 100),
                "1% Buy Limit in effect. Still straining out the whales!"
            );
        }

    }

    // Goodbye, blue sky ...
    function disownCat() public onlyOwner {
        /*
           |\__/,|   (`\
           |o o  |__ _) |
         _.( T   )  `  /
        ((_ `^--' /_<  \
        `` `-'(((/  (((/
        */
        renounceOwnership(); /* FOREVER! */
    }

}

// SQRCAT complete.