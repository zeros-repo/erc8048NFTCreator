// SPDX-License-Identifier: MIT
//To promote the adoption of ERC-8048
/// Copyright (c) 2026 _zero
pragma solidity ^0.8.24;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.7.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.7.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract erc8048NFT is ERC721URIStorage,Ownable {
    constructor(string memory name,string memory sym,address creator) ERC721(name,sym) Ownable(creator) {
        
    }

    uint256 private _nextTokenId;
    
    mapping(uint => mapping(string =>bytes)) private metadatas;

    mapping(uint => bool) public nftdatalock;

    event MetadataSet(uint256 indexed tokenId, string indexed indexedKey, string key, bytes value);

    function createNFT(bytes memory itemname,bytes memory itemdesc,string memory imageType,bytes memory imageData) public returns (uint256) {
        require(msg.sender == owner());
        uint256 tokenId = _nextTokenId++;
        _mint(msg.sender, tokenId);
        metadatas[tokenId]["name"] = itemname;
        metadatas[tokenId]["desc"] = itemdesc;
        
        emit MetadataSet(tokenId, "name", "name", itemname);
        emit MetadataSet(tokenId, "desc", "desc", itemdesc);

        if (metadatas[tokenId]["metadata_uri"].length == 0 && keccak256(bytes(imageType)) == keccak256(bytes("svg"))) {
            //bytes memory temp = bytes('{"image":"onchain:image/svg+xml?key=svg"}');
            bytes memory temp = bytes(string.concat('{"name":"', string(itemname), '","description":"', string(itemdesc), '","image":"onchain:image/svg+xml?key=svg"}'));
        
            metadatas[tokenId]["metadata_uri"] = temp;
            emit MetadataSet(tokenId, "metadata_uri", "metadata_uri", temp);

            _setTokenURI(tokenId, "onchain:application/json?key=metadata_uri");
            metadatas[tokenId]["svg"] = imageData;
            emit MetadataSet(tokenId, "svg", "svg", imageData);
        }

        if (metadatas[tokenId]["metadata_uri"].length == 0 && keccak256(bytes(imageType)) == keccak256(bytes("png"))) {
            //bytes memory temp = bytes('{"image":"onchain:image/svg+xml?key=svg"}');
            bytes memory temp = bytes(string.concat('{"name":"', string(itemname), '","description":"', string(itemdesc), '","image":"onchain:image/png?key=png"}'));
        
            metadatas[tokenId]["metadata_uri"] = temp;
            emit MetadataSet(tokenId, "metadata_uri", "metadata_uri", temp);

            _setTokenURI(tokenId, "onchain:application/json?key=metadata_uri");
            metadatas[tokenId]["png"] = imageData;
            emit MetadataSet(tokenId, "png", "png", imageData);
        }

        if (metadatas[tokenId]["metadata_uri"].length == 0 && keccak256(bytes(imageType)) == keccak256(bytes("jpeg"))) {
            //bytes memory temp = bytes('{"image":"onchain:image/svg+xml?key=svg"}');
            bytes memory temp = bytes(string.concat('{"name":"', string(itemname), '","description":"', string(itemdesc), '","image":"onchain:image/jpeg?key=jpeg"}'));
        
            metadatas[tokenId]["metadata_uri"] = temp;
            emit MetadataSet(tokenId, "metadata_uri", "metadata_uri", temp);

            _setTokenURI(tokenId, "onchain:application/json?key=metadata_uri");
            metadatas[tokenId]["jpeg"] = imageData;
            emit MetadataSet(tokenId, "jpeg", "jpeg", imageData);
        }
        
        
        
        return tokenId;
    }

    function settokenURI(uint nftid, string memory tokenURI) public {
        require(msg.sender == owner());
        _setTokenURI(nftid, tokenURI);
        
    }

    function setMetadata(uint256 tokenId, string calldata key,bytes memory registerdata) public {
        require(msg.sender == owner());
        require(nftdatalock[tokenId] == false);
        metadatas[tokenId][key] = registerdata;

        emit MetadataSet(tokenId, key, key, registerdata);

        
        
            
        

        emit MetadataUpdate(tokenId);
    }

    

    function metadata(uint256 tokenId, string calldata key) public view returns (bytes memory){

        if (keccak256(bytes(key)) == keccak256(bytes("full_onchain_image"))){
            if ( metadatas[tokenId]["png"].length > 0 ||metadatas[tokenId]["jpeg"].length > 0 || metadatas[tokenId]["svg"].length > 0 ) {
                return bytes("true");
            }
        }
        
        return metadatas[tokenId][key];
    }

    //Only on-chain data is subject to locking.
    function setNFTDataLock(uint nftid) public {
        require(msg.sender == owner());
        nftdatalock[nftid] = true;
    }

     function supportsInterface(bytes4 interfaceID) override public view returns (bool){
        if(interfaceID ==  0xdf670be1 || interfaceID == 0x01ffc9a7 || interfaceID ==  type(IERC8048TokenMetadataLockandTypesLists).interfaceId){
            return true;
        }

        return super.supportsInterface(interfaceID);

    }

    

}

interface IERC8048TokenMetadataLockandTypesLists {
    function setNFTDataLock(uint nftid) external;
    
}

contract erc8048NFTCreator {

    

   function createNFT(string memory name,string memory sym)
        public
        returns (erc8048NFT tokenAddress)
    {
        return new erc8048NFT(name,sym,msg.sender);
        
    }

}

