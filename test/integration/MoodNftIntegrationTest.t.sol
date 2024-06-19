// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {MoodNft} from "../../src/MoodNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {console} from "forge-std/console.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract MoonNftTest is Test{
    MoodNft public moodNft;
    string public constant HAPPY_SVG_IMAGE_URI = "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
    string public constant SAD_SVG_IMAGE_URI = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIvPgogIDxwYXRoIGZpbGw9IiNFNkU2RTYiIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiLz4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPgo8L3N2Zz4==";
    string public constant HAPPY_SVG_URI = "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ01qQXdJREl3TUNJZ2QybGtkR2c5SWpRd01DSWdJR2hsYVdkb2REMGlOREF3SWlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpUGdvZ0lEeGphWEpqYkdVZ1kzZzlJakV3TUNJZ1kzazlJakV3TUNJZ1ptbHNiRDBpZVdWc2JHOTNJaUJ5UFNJM09DSWdjM1J5YjJ0bFBTSmliR0ZqYXlJZ2MzUnliMnRsTFhkcFpIUm9QU0l6SWk4K0NpQWdQR2NnWTJ4aGMzTTlJbVY1WlhNaVBnb2dJQ0FnUEdOcGNtTnNaU0JqZUQwaU5qRWlJR041UFNJNE1pSWdjajBpTVRJaUx6NEtJQ0FnSUR4amFYSmpiR1VnWTNnOUlqRXlOeUlnWTNrOUlqZ3lJaUJ5UFNJeE1pSXZQZ29nSUR3dlp6NEtJQ0E4Y0dGMGFDQmtQU0p0TVRNMkxqZ3hJREV4Tmk0MU0yTXVOamtnTWpZdU1UY3ROalF1TVRFZ05ESXRPREV1TlRJdExqY3pJaUJ6ZEhsc1pUMGlabWxzYkRwdWIyNWxPeUJ6ZEhKdmEyVTZJR0pzWVdOck95QnpkSEp2YTJVdGQybGtkR2c2SURNN0lpOCtDand2YzNablBnPT0ifQ==";


    address USER = makeAddr("user");
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }

    function testViewTokenURIIntegration() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log(moodNft.tokenURI(0));
    }

    function testFlipTokenToSad() public{
        string memory whatEverString = abi.decode(0x608060405234801561001057600080fd5b5060405161170638038061170683398101604081905261002f91610169565b60405180604001604052806008815260200167135bdbd90813919560c21b8152506040518060400160405280600281526020016126a760f11b815250816000908161007a919061025b565b506001610087828261025b565b5050600060065550600861009b828261025b565b5060076100a8838261025b565b505050610319565b634e487b7160e01b600052604160045260246000fd5b600082601f8301126100d757600080fd5b81516001600160401b038111156100f0576100f06100b0565b604051601f8201601f19908116603f011681016001600160401b038111828210171561011e5761011e6100b0565b60405281815283820160200185101561013657600080fd5b60005b8281101561015557602081860181015183830182015201610139565b506000918101602001919091529392505050565b6000806040838503121561017c57600080fd5b82516001600160401b0381111561019257600080fd5b61019e858286016100c6565b602085015190935090506001600160401b038111156101bc57600080fd5b6101c8858286016100c6565b9150509250929050565b600181811c908216806101e657607f821691505b60208210810361020657634e487b7160e01b600052602260045260246000fd5b50919050565b601f82111561025657806000526020600020601f840160051c810160208510156102335750805b601f840160051c820191505b81811015610253576000815560010161023f565b50505b505050565b81516001600160401b03811115610274576102746100b0565b6102888161028284546101d2565b8461020c565b6020601f8211600181146102bc57600083156102a45750848201515b600019600385901b1c1916600184901b178455610253565b600084815260208120601f198516915b828110156102ec57878501518255602094850194600190920191016102cc565b508482101561030a5786840151600019600387901b60f8161c191681555b50505050600190811b01905550565b6113de806103286000396000f3fe608060405234801561001057600080fd5b50600436106100f55760003560e01c806370a0823111610097578063c1a147a011610066578063c1a147a0146101ff578063c2229fea14610212578063c87b56dd1461021a578063e985e9c51461022d57600080fd5b806370a08231146101b057806395d89b41146101d1578063a22cb465146101d9578063b88d4fde146101ec57600080fd5b8063095ea7b3116100d3578063095ea7b31461016257806323b872dd1461017757806342842e0e1461018a5780636352211e1461019d57600080fd5b806301ffc9a7146100fa57806306fdde0314610122578063081812fc14610137575b600080fd5b61010d610108366004610e60565b610240565b60405190151581526020015b60405180910390f35b61012a610292565b6040516101199190610ecd565b61014a610145366004610ee0565b610324565b6040516001600160a01b039091168152602001610119565b610175610170366004610f15565b61034d565b005b610175610185366004610f3f565b61035c565b610175610198366004610f3f565b6103ec565b61014a6101ab366004610ee0565b61040c565b6101c36101be366004610f7c565b610417565b604051908152602001610119565b61012a61045f565b6101756101e7366004610f97565b61046e565b6101756101fa366004610fe9565b610479565b61017561020d366004610ee0565b610491565b6101756104ee565b61012a610228366004610ee0565b61052b565b61010d61023b3660046110cd565b610704565b60006001600160e01b031982166380ac58cd60e01b148061027157506001600160e01b03198216635b5e139f60e01b145b8061028c57506301ffc9a760e01b6001600160e01b03198316145b92915050565b6060600080546102a190611100565b80601f01602080910402602001604051908101604052809291908181526020018280546102cd90611100565b801561031a5780601f106102ef5761010080835404028352916020019161031a565b820191906000526020600020905b8154815290600101906020018083116102fd57829003601f168201915b5050505050905090565b600061032f82610732565b506000828152600460205260409020546001600160a01b031661028c565b61035882823361076b565b5050565b6001600160a01b03821661038b57604051633250574960e11b8152600060048201526024015b60405180910390fd5b6000610398838333610778565b9050836001600160a01b0316816001600160a01b0316146103e6576040516364283d7b60e01b81526001600160a01b0380861660048301526024820184905282166044820152606401610382565b50505050565b61040783838360405180602001604052806000815250610479565b505050565b600061028c82610732565b60006001600160a01b038216610443576040516322718ad960e21b815260006004820152602401610382565b506001600160a01b031660009081526003602052604090205490565b6060600180546102a190611100565b610358338383610873565b61048484848461035c565b6103e63385858585610912565b60008181526009602052604081205460ff1660018111156104b4576104b461113a565b036104d4576000908152600960205260409020805460ff19166001179055565b6000818152600960205260409020805460ff191690555b50565b6104fa33600654610a3d565b600680546000908152600960205260408120805460ff191660011790558154919061052483611166565b9190505550565b6060806000808481526009602052604090205460ff1660018111156105525761055261113a565b036105e9576008805461056490611100565b80601f016020809104026020016040519081016040528092919081815260200182805461059090611100565b80156105dd5780601f106105b2576101008083540402835291602001916105dd565b820191906000526020600020905b8154815290600101906020018083116105c057829003601f168201915b50505050509050610677565b600780546105f690611100565b80601f016020809104026020016040519081016040528092919081815260200182805461062290611100565b801561066f5780601f106106445761010080835404028352916020019161066f565b820191906000526020600020905b81548152906001019060200180831161065257829003601f168201915b505050505090505b60408051808201909152601d81527f646174613a6170706c69636174696f6e2f6a736f6e3b6261736536342c00000060208201526106dc6106b6610292565b836040516020016106c892919061117f565b604051602081830303815290604052610a57565b6040516020016106ed929190611293565b604051602081830303815290604052915050919050565b6001600160a01b03918216600090815260056020908152604080832093909416825291909152205460ff1690565b6000818152600260205260408120546001600160a01b03168061028c57604051637e27328960e01b815260048101849052602401610382565b6104078383836001610a7d565b6000828152600260205260408120546001600160a01b03908116908316156107a5576107a5818486610b83565b6001600160a01b038116156107e3576107c2600085600080610a7d565b6001600160a01b038116600090815260036020526040902080546000190190555b6001600160a01b03851615610812576001600160a01b0385166000908152600360205260409020805460010190555b60008481526002602052604080822080546001600160a01b0319166001600160a01b0389811691821790925591518793918516917fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef91a490505b9392505050565b6001600160a01b0382166108a557604051630b61174360e31b81526001600160a01b0383166004820152602401610382565b6001600160a01b03838116600081815260056020908152604080832094871680845294825291829020805460ff191686151590811790915591519182527f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31910160405180910390a3505050565b6001600160a01b0383163b15610a3657604051630a85bd0160e11b81526001600160a01b0384169063150b7a02906109549088908890879087906004016112c2565b6020604051808303816000875af192505050801561098f575060408051601f3d908101601f1916820190925261098c918101906112ff565b60015b6109f8573d8080156109bd576040519150601f19603f3d011682016040523d82523d6000602084013e6109c2565b606091505b5080516000036109f057604051633250574960e11b81526001600160a01b0385166004820152602401610382565b805181602001fd5b6001600160e01b03198116630a85bd0160e11b14610a3457604051633250574960e11b81526001600160a01b0385166004820152602401610382565b505b5050505050565b610358828260405180602001604052806000815250610be7565b606061028c82604051806060016040528060408152602001611369604091396001610bff565b8080610a9157506001600160a01b03821615155b15610b53576000610aa184610732565b90506001600160a01b03831615801590610acd5750826001600160a01b0316816001600160a01b031614155b8015610ae05750610ade8184610704565b155b15610b095760405163a9fbf51f60e01b81526001600160a01b0384166004820152602401610382565b8115610b515783856001600160a01b0316826001600160a01b03167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a45b505b5050600090815260046020526040902080546001600160a01b0319166001600160a01b0392909216919091179055565b610b8e838383610d7f565b610407576001600160a01b038316610bbc57604051637e27328960e01b815260048101829052602401610382565b60405163177e802f60e01b81526001600160a01b038316600482015260248101829052604401610382565b610bf18383610de5565b610407336000858585610912565b60608351600003610c1f575060408051602081019091526000815261086c565b600082610c5057600385516004610c36919061131c565b610c41906002611333565b610c4b9190611346565b610c75565b600385516002610c609190611333565b610c6a9190611346565b610c7590600461131c565b905060008167ffffffffffffffff811115610c9257610c92610fd3565b6040519080825280601f01601f191660200182016040528015610cbc576020820181803683370190505b50905060018501602082018788518901602081018051600082525b82841015610d32576003840193508351603f8160121c168701518653600186019550603f81600c1c168701518653600186019550603f8160061c168701518653600186019550603f8116870151865350600185019450610cd7565b905250508515610d7357600388510660018114610d565760028114610d6957610d71565b603d6001830353603d6002830353610d71565b603d60018303535b505b50909695505050505050565b60006001600160a01b03831615801590610ddd5750826001600160a01b0316846001600160a01b03161480610db95750610db98484610704565b80610ddd57506000828152600460205260409020546001600160a01b038481169116145b949350505050565b6001600160a01b038216610e0f57604051633250574960e11b815260006004820152602401610382565b6000610e1d83836000610778565b90506001600160a01b03811615610407576040516339e3563760e11b815260006004820152602401610382565b6001600160e01b0319811681146104eb57600080fd5b600060208284031215610e7257600080fd5b813561086c81610e4a565b60005b83811015610e98578181015183820152602001610e80565b50506000910152565b60008151808452610eb9816020860160208601610e7d565b601f01601f19169290920160200192915050565b60208152600061086c6020830184610ea1565b600060208284031215610ef257600080fd5b5035919050565b80356001600160a01b0381168114610f1057600080fd5b919050565b60008060408385031215610f2857600080fd5b610f3183610ef9565b946020939093013593505050565b600080600060608486031215610f5457600080fd5b610f5d84610ef9565b9250610f6b60208501610ef9565b929592945050506040919091013590565b600060208284031215610f8e57600080fd5b61086c82610ef9565b60008060408385031215610faa57600080fd5b610fb383610ef9565b915060208301358015158114610fc857600080fd5b809150509250929050565b634e487b7160e01b600052604160045260246000fd5b60008060008060808587031215610fff57600080fd5b61100885610ef9565b935061101660208601610ef9565b925060408501359150606085013567ffffffffffffffff81111561103957600080fd5b8501601f8101871361104a57600080fd5b803567ffffffffffffffff81111561106457611064610fd3565b604051601f8201601f19908116603f0116810167ffffffffffffffff8111828210171561109357611093610fd3565b6040528181528282016020018910156110ab57600080fd5b8160208401602083013760006020838301015280935050505092959194509250565b600080604083850312156110e057600080fd5b6110e983610ef9565b91506110f760208401610ef9565b90509250929050565b600181811c9082168061111457607f821691505b60208210810361113457634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052602160045260246000fd5b634e487b7160e01b600052601160045260246000fd5b60006001820161117857611178611150565b5060010190565b683d913730b6b2911d1160b91b815282516000906111a4816009850160208801610e7d565b7f222c20226465736372697074696f6e223a22416e204e465420746861742072656009918401918201527f666c6563747320746865206d6f6f64206f6620746865206f776e65722c20313060298201526e018129037b71021b430b4b71091161608d1b60498201527f2261747472696275746573223a205b7b2274726169745f74797065223a20226d60588201527f6f6f64696e657373222c202276616c7565223a203130307d5d2c2022696d616760788201526332911d1160e11b6098820152835161127881609c840160208801610e7d565b61227d60f01b609c9290910191820152609e01949350505050565b600083516112a5818460208801610e7d565b8351908301906112b9818360208801610e7d565b01949350505050565b6001600160a01b03858116825284166020820152604081018390526080606082018190526000906112f590830184610ea1565b9695505050505050565b60006020828403121561131157600080fd5b815161086c81610e4a565b808202811582820484141761028c5761028c611150565b8082018082111561028c5761028c611150565b60008261136357634e487b7160e01b600052601260045260246000fd5b50049056fe4142434445464748494a4b4c4d4e4f505152535455565758595a6162636465666768696a6b6c6d6e6f707172737475767778797a303132333435363738392b2fa26469706673582212202231049ac3a435e60b07825ab2a0fad57d79e3635bf30c3ee4e8736c5659ed9b64736f6c634300081a003300000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000058a646174613a696d6167652f7376672b786d6c3b6261736536342c50484e325a79423361575230614430694d5441794e4842344969426f5a576c6e61485139496a45774d6a527765434967646d6c6c64304a76654430694d434177494445774d6a51674d5441794e43496765473173626e4d39496d6830644841364c79393364336375647a4d7562334a6e4c7a49774d44417663335a6e496a344b49434138634746306143426d615778735053496a4d7a4d7a4969426b50534a4e4e54457949445930517a49324e4334324944593049445930494449324e43343249445930494455784d6e4d794d4441754e6941304e4467674e445134494451304f4341304e4467744d6a41774c6a59674e4451344c5451304f464d334e546b754e4341324e4341314d5449674e6a5236625441674f444977597930794d4455754e4341774c544d334d6930784e6a59754e69307a4e7a49744d7a6379637a45324e6934324c544d334d69417a4e7a49744d7a637949444d334d6941784e6a59754e69417a4e7a49674d7a63794c5445324e69343249444d334d69307a4e7a49674d7a63796569497650676f67494478775958526f49475a706247773949694e464e6b55325254596949475139496b30314d5449674d545177597930794d4455754e4341774c544d334d6941784e6a59754e69307a4e7a49674d7a6379637a45324e69343249444d334d69417a4e7a49674d7a637949444d334d6930784e6a59754e69417a4e7a49744d7a63794c5445324e6934324c544d334d69307a4e7a49744d7a6379656b30794f4467674e444978595451344c6a4178494451344c6a4178494441674d43417849446b32494441674e4467754d4445674e4467754d4445674d434177494445744f5459674d4870744d7a6332494449334d6d67744e4467754d574d744e433479494441744e7934344c544d754d6930344c6a45744e793430517a59774e4341324d7a59754d5341314e6a49754e5341314f5463674e544579494455354e334d744f5449754d53417a4f5334784c546b314c6a67674f4467754e6d4d744c6a4d674e4334794c544d754f5341334c6a51744f433478494463754e45677a4e6a42684f434134494441674d4341784c5467744f433430597a51754e4330344e43347a494463304c6a55744d5455784c6a59674d5459774c5445314d533432637a45314e533432494459334c6a4d674d545977494445314d533432595467674f434177494441674d533034494467754e4870744d6a51744d6a4930595451344c6a4178494451344c6a4178494441674d434178494441744f5459674e4467754d4445674e4467754d4445674d434177494445674d4341354e6e6f694c7a344b49434138634746306143426d615778735053496a4d7a4d7a4969426b50534a4e4d6a6734494451794d5745304f4341304f434177494445674d4341354e6941774944513449445134494441674d5341774c546b3249444236625449794e4341784d544a6a4c5467314c6a55674d4330784e5455754e6941324e79347a4c5445324d4341784e5445754e6d4534494467674d434177494441674f4341344c6a526f4e4467754d574d304c6a49674d4341334c6a67744d793479494467754d5330334c6a51674d7934334c5451354c6a55674e4455754d7930344f43343249446b314c6a67744f4467754e6e4d354d69417a4f53347849446b314c6a67674f4467754e6d4d754d7941304c6a49674d793435494463754e4341344c6a45674e793430534459324e474534494467674d434177494441674f4330344c6a52444e6a59334c6a59674e6a41774c6a4d674e546b334c6a55674e544d7a494455784d6941314d7a4e36625445794f4330784d544a684e4467674e4467674d434178494441674f5459674d4341304f4341304f434177494445674d4330354e6941776569497650676f384c334e325a7a343d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000222646174613a696d6167652f7376672b786d6c3b6261736536342c50484e325a79423261575633516d393450534977494441674d6a4177494449774d43496764326c6b64476739496a51774d4349674947686c6157646f644430694e4441774969423462577875637a30696148523063446f764c336433647935334d793576636d63764d6a41774d43397a646d636950676f674944786a61584a6a6247556759336739496a45774d43496759336b39496a45774d4349675a6d6c7362443069655756736247393349694279505349334f434967633352796232746c50534a696247466a61794967633352796232746c4c5864705a48526f5053497a4969382b43694167504763675932786863334d39496d56355a584d6950676f674943416750474e70636d4e735a53426a654430694e6a456949474e35505349344d694967636a30694d5449694c7a344b494341674944786a61584a6a6247556759336739496a45794e79496759336b39496a677949694279505349784d69497650676f67494477765a7a344b49434138634746306143426b50534a744d544d324c6a6778494445784e6934314d324d754e6a6b674d6a59754d5463744e6a51754d5445674e4449744f4445754e5449744c6a637a4969427a64486c735a5430695a6d6c73624470756232356c4f79427a64484a766132553649474a7359574e724f79427a64484a766132557464326c6b6447673649444d374969382b436a777663335a6e50673d3d000000000000000000000000000000000000000000000000000000000000);
        vm.startPrank(USER);
        console.log(USER);
        moodNft.mintNft();
        moodNft.flipMood(0);
        vm.stopPrank();
        console.log(moodNft.tokenURI(0));
        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0)))== keccak256(abi.encodePacked(HAPPY_SVG_URI)));
    }
}

