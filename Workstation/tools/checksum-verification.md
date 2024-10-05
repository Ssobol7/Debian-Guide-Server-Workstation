# How to Verify the Checksum of an ISO Image (MD5, SHA256, SHA512) on Linux

&nbsp;

> [!IMPORTANT]
> To ensure the integrity and authenticity of the downloaded Debian 12 ISO image, it's important to verify its checksum. Typically, MD5, SHA256, or SHA512 algorithms are used. Checksums for downloadable files are usually provided on the developer’s website.
>
> Always compare the generated checksums with the official ones provided by the developer on their website.


&nbsp;

#### Step 1: Download the Checksum and Signature File (if needed)

You can find checksums and signature files for Debian ISO images on the official Debian download pages:

- [Debian](https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/)

![Screenshot_2024-10-05_08-40-50](https://github.com/user-attachments/assets/1c5709b7-e167-400d-ae61-8b030197386b)


&nbsp;

#### Step 2: Check the ISO Image’s Checksum

Once you've downloaded the ISO image, you can use the following commands to verify its checksum:

- **SHA256**:

   ```bash
   sha256sum /path/to/debian-12.7.0-amd64-netinst.iso
   ```

- **SHA512**:

   ```bash
   sha512sum /path/to/debian-12.7.0-amd64-netinst.iso
   ```

- **MD5** (if used):

   ```bash
   md5sum /path/to/debian-12.7.0-amd64-netinst.iso
   ```

&nbsp;

#### Step 3: Compare the Result with the Provided Checksum

After running the command, you will get an output similar to this:

```bash
3f2f65ad9fb9e6c601b5de7313f24c9a6f3e748a7b9f6f02b1e3d9f6d4abce25  debian-12.7.0-amd64-netinst.iso
```

This string is the file’s checksum. Compare it with the checksum provided on the Debian website to ensure they match.

&nbsp;

#### Step 4: (Optional) Verify the Signature File (GPG)

Debian also provides `.sign` and `.gpg` signature files, which can be used to verify the authenticity of the checksum using GPG.

1. First, import the Debian developer keys:

   ```bash
   gpg --keyserver keyring.debian.org --recv-keys <KEY-ID>
   ```

2. Then, use the following command to verify the signature:

   ```bash
   gpg --verify SHA256SUMS.sign SHA256SUMS
   ```

   This will verify that the checksum listed in the `SHA256SUMS` file has not been altered.


&nbsp;

---

&nbsp;
