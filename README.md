# Packer Cloud Images

Build your own cloud images from scratch within minutes.

## Features

Most cloud providers provide prebuilt images for different Linux distributions through a marketplace. The quality and usability differs from image to image. Therefore it makes sense to build your own images to provide VMs tailored to your use case. In addition it gives you full control how and when the images are updated.

This repository makes use of Packer to build custom images for a few Linux distributions. These images should fullfil the following requirements:

- Minimal installation
- Support for OpenStack

After building the images upload them to the specific cloud and start spawn VMs from them.

## Requirements

Ensure the following requirements are installed:

- [Packer](https://www.packer.io/)
- QEMU / KVM

## Installation

Follow the steps below to build the images:

```shell
sudo PACKER_LOG=1 /path/to/packer build centos7-lvm-qemu.json
```

Pick any of the available JSON files to build an image for the required distribution.

## Test the image using kvm

Source: <https://stafwag.github.io/blog/blog/2019/03/03/howto-use-centos-cloud-images-with-cloud-init/>

- Install cloud-utils on the host for converting the user-data to a disk image
- Create a copy of the generated image as the root disk of the VM
- Create a cloud-config user data file

```shell

cloud-localds my-seed.img cloud-config.yml
sudo cp my-seed.img /var/lib/libvirt/images/test/my-seed.img

sudo cp images/centos-7-lvm/localhost.localdomain /var/lib/libvirt/images/test/test.qcow2

# resize disk (optional)
sudo qemu-img resize /var/lib/libvirt/images/test/test.qcow2 15G

virt-install \
--memory 2048 \
--vcpus 2 \
--name centos-7-lvm \
--disk /var/lib/libvirt/images/test/test.qcow2,device=disk \
--disk /var/lib/libvirt/images/test/my-seed.img,device=cdrom \
--os-type Linux \
--os-variant centos7.0 \
--virt-type kvm \
--graphics spice \
--network default \
--import
```

## Openstack

Requirements:

- <https://docs.openstack.org/image-guide/openstack-images.html>
- <https://docs.openstack.org/image-guide/centos-image.html>
- <https://github.com/smerrill/openstack-centos-image/blob/master/kickstart.ks>

## After resize of root disk

```shell
growpart /dev/vda 2
pvresize /dev/vda2
```

vg has now more free space to allocate

## Contributions

Contributions are more than welcome! Please feel free to open new issues or
pull requests.

Thanks to Adfinis SyGroup for their [packer-cloud-images](https://github.com/adfinis-sygroup/packer-cloud-images) source

## License

GNU GENERAL PUBLIC LICENSE Version 3

See the [`LICENSE`](LICENSE) file.
