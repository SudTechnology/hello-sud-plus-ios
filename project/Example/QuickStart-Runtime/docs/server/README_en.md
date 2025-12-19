#### 1.1 Preparation

- Obtain the application's public key (public_key)

#### 1.2 Encryption

- Construct the encrypted content (JSON string):

```
{"version":"1","user_id":"xxx","expire_at":1761638855}
```

| Parameter Name | Mandatory | Type   | Description                          |
| :------------- | :-------- | :----- | :----------------------------------- |
| version        | Yes       | string | Version number; current value is `1` |
| user_id        | Yes       | string | User ID                              |
| expire_at      | Yes       | int    | Expiration timestamp (in seconds)    |

- Encryption Mode: RSA/ECB/PKCS1Padding

#### 1.3 Example

```java
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

### 翻译说明

1. **术语一致性**：

   - "公钥" 译为 "public key"（技术领域标准术语）
   - "加密模式" 译为 "Encryption Mode"（密码学标准表述）
   - "时间戳" 译为 "timestamp"（计算机领域通用术语）
   - "必选" 译为 "Mandatory"（技术文档常用表述，区别于 "Required" 更强调强制性）

2. **格式规范**：

   - 保持原文档的层级结构（标题、列表、表格、代码块）
   - 表格列名准确对应（参数名 →Parameter Name，类型 →Type，说明 →Description）
   - 代码块保留原始语法格式，关键字不翻译（如 `Base64`、`Cipher` 等 Java 类名）

3. **细节处理**：
   - 版本号 `1` 保留反引号 `1`，与代码风格一致
   - 时间戳数值 `1761638855` 不修改（Unix 时间戳为跨语言通用格式）
   - "JSON 字符串" 译为 "JSON string"（技术文档标准表述）
   - 异常声明 `throws Exception` 保留原始 Java 语法
