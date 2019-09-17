===================
Packer Cloud Images
===================

|Travis| |License|

.. |Travis| image:: https://img.shields.io/travis/adfinis-sygroup/packer-cloud-images.svg?style=flat-square
   :target: https://travis-ci.org/adfinis-sygroup/packer-cloud-images
.. |License| image:: https://img.shields.io/github/license/adfinis-sygroup/packer-cloud-images.svg?style=flat-square
   :target: LICENSE

Build your own AWS and Azure Packer images from scratch within minutes.

Features
========
Most cloud providers like AWS or Azure provide prebuilt images for different
Linux distributions through a marketplace. The quality and usability differs
from image to image. Therefore it makes sense to build your own images to
provide VMs tailored to your use case. In addition it gives you full control
how and when the images are updated.

This repository makes use of Packer_ and Ansible_ to build custom images for a
few Linux distributions. These images should fullfil the following requirements:

* Minimal installation
* Tailored to the corresponding cloud
* Support for OpenStack

After building the images upload them to the specific cloud and start spawn VMs
from them.

Requirements
============
Ensure the following requirements are installed:

* Ansible_
* Packer_
* QEMU / KVM

.. _Packer: https://www.packer.io/intro/getting-started/install.html

Installation
============
Follow the steps below to build the images:

.. code:: shell

       $ sudo PACKER_LOG=1 /path/to/packer build centos7-lvm-qemu.json

Pick any of the available JSON files to build an image for the required
distribution.

Test
====

https://stafwag.github.io/blog/blog/2019/03/03/howto-use-centos-cloud-images-with-cloud-init/

.. code-block:: shell

       $ sudo apt install cloud-utils
       $ cloud-localds my-seed.img cloud-config.yml
       $ virt-install \
       --memory 2048 \
       --vcpus 2 \
       --name test \
       --disk /var/lib/libvirt/images/test/test.qcow2,device=disk \
       --disk /var/lib/libvirt/images/test/my-seed.img,device=cdrom \
       --os-type Linux \
       --os-variant centos7.0 \
       --virt-type kvm \
       --graphics spice \
       --network default \
       --import

Openstack
=========

https://docs.openstack.org/image-guide/openstack-images.html
https://docs.openstack.org/image-guide/centos-image.html

https://github.com/smerrill/openstack-centos-image/blob/master/kickstart.ks

After resize of root disk
=========================

.. code-block:: shell

       growpart /dev/vda 2
       pvresize /dev/vda2

vg has now more free space to allocate

Contributions
=============
Contributions are more than welcome! Please feel free to open new issues or
pull requests.

License
=======
GNU GENERAL PUBLIC LICENSE Version 3

See the `LICENSE`_ file.

.. _LICENSE: LICENSE
