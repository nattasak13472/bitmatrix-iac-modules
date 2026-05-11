# EBS Volume Module

This module manages Amazon Elastic Block Store (EBS) Volumes and optionally handles their attachment to EC2 instances. It ensures volumes are encrypted by default.

## 🚀 Example Usage

This example demonstrates how to create a standalone EC2 instance (e.g., for a GitLab Runner or database) and attach a secondary data volume to it.

```hcl
# 1. Create the EC2 Instance
module "gitlab_runner" {
  source = "../../compute/ec2-instance"

  project       = "bitmatrix"
  environment   = "prod"
  name          = "gitlab-runner"
  instance_type = "t3.medium"
  subnet_id     = module.vpc.private_subnets[0]
  
  # ... other EC2 config
}

# 2. Create and Attach the EBS Volume
module "runner_data_disk" {
  source = "../../storage/ebs"

  project           = "bitmatrix"
  environment       = "prod"
  volume_name       = "runner-data"
  availability_zone = module.gitlab_runner.availability_zone
  
  size = 100 # 100 GB
  type = "gp3"
  
  # Ensure the volume is attached to the instance we just created
  instance_id = module.gitlab_runner.id
  device_name = "/dev/sdf"
}
```

---

## 🛠 OS-Level Setup (Post-Attachment)

Once Terraform successfully attaches the EBS volume to your Amazon Linux EC2 instance, the operating system sees it as a raw, unformatted disk. **You must format and mount the disk before you can use it.**

SSH into your Amazon Linux instance and follow these steps:

### Step 1: Identify the Disk
Run `lsblk` to see the attached disks.
```bash
lsblk
```
*Note: Even though you specified `/dev/sdf` in Terraform, modern Amazon Linux instances often rename NVMe devices. Your disk will likely appear as `/dev/nvme1n1` or similar.*

### Step 2: Check for an existing File System
Verify the disk is completely empty (it should return `data`).
```bash
sudo file -s /dev/nvme1n1
```
*(If it returns something like `SGI XFS filesystem`, do **not** format it again, or you will lose data!)*

### Step 3: Format the Disk
Create an XFS file system (the recommended standard for Amazon Linux).
```bash
sudo mkfs -t xfs /dev/nvme1n1
```

### Step 4: Mount the Disk
Create a directory where you want to access the data, then mount the disk to it.
```bash
sudo mkdir /data
sudo mount /dev/nvme1n1 /data
```

### Step 5: Make the Mount Persistent (Critical)
If you reboot your instance right now, the disk will unmount. You must add it to the `fstab` file to ensure it mounts automatically on boot.

1. Find the UUID of your new disk:
   ```bash
   sudo blkid
   ```
   *(Look for the UUID of `/dev/nvme1n1`)*

2. Open the `fstab` file:
   ```bash
   sudo nano /etc/fstab
   ```

3. Add the following line to the bottom of the file (replace `YOUR-UUID-HERE` with the actual UUID):
   ```text
   UUID=YOUR-UUID-HERE  /data  xfs  defaults,nofail  0  2
   ```
   *Note: The `nofail` option is critical. It ensures that if the EBS volume fails to attach for some reason, the EC2 instance will still boot up normally.*

4. Verify your `fstab` entry is correct (if this command returns no errors, you are safe):
   ```bash
   sudo mount -a
   ```

You can now start writing data to the `/data` directory!
