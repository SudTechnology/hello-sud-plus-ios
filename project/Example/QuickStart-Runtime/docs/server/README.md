#### 1.1 准备
- 获取应用的公钥（public_key）

#### 1.2 加密

- 构造加密内容 (json字符串):

```
{"version":"1","user_id":"xxx","expire_at":1761638855}
```

|参数名|必选|类型|说明|
|:----    |:---|:----- |-----   |
|version |是  |string |版本号， 目前值为 `1`   |
|user_id |是  |string | 用户id    |
|expire_at     |是  |int | 过期时间戳 (秒)    |

- 加密模式： RSA/ECB/PKCS1Padding

#### 1.3 例子
```
    public String encrypt(String data, String publicKeyStr) throws Exception {
		byte[] key = Base64.getDecoder().decode(publicKeyStr);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(key);
        KeyFactory factory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = factory.generatePublic(keySpec);

        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] bytes = cipher.doFinal(data.getBytes());
        return Base64.getEncoder().encodeToString(bytes);
    }
```