# talos-i915-sriov-kernel
Talos installer and build artifacts with the [intel/linux-intel-lts](https://github.com/intel/linux-intel-lts) kernel to support SR-IOV on i915 devices

# WARNING - Here be dragons
This is not stable software, you will very possibly encounter bugs and I offer no guarantees of any kind. Intel has a note on the kernel repo stating that "this should only be used for Intel platform feature evaluation and not for production." You may get lucky and not run into any issues, but be prepared to back out just in case. 

# Known Issues
- QuickSync HEVC->H.264 video corruption on Arrow Lake-H (investigating)

# Installation
- Use this installer image (`ghcr.io/mikesmitty/installer`) like so `talosctl upgrade --image ghcr.io/mikesmitty/test-i915-installer:$TALOS_VERSION -n $YOUR_NODE`

## Alternate boot options
If the installer image isn't your cup of tea you can also use the `ghcr.io/mikesmitty/imager` image to generate other types of install media (e.g. kernel, initramfs for PXE) with these docs: https://www.talos.dev/v1.11/talos-guides/install/boot-assets/#imager

## System Extensions
This kernel is compiled only with the i915 and qemu-guest-agent system extensions because that's the only ones I use personally, but I may add others later.

# Proxmox SR-IOV Module
Support for SR-IOV is required on both host and guest. On Proxmox hosts it can be added using the [strongtz/i915-sriov-dkms](https://github.com/strongtz/i915-sriov-dkms) module that I wrote up instructions for installing here: https://gist.github.com/mikesmitty/1b353fa1cc95922bd15f914da2cd3773

## Xe driver
Alternatively, the new xe driver that replaces i915 will have SR-IOV enabled behind a `xe.force_probe` flag for many newer generations as of kernel 6.18. You can see which ones have it enabled [here](https://github.com/torvalds/linux/blob/918bd789d62e6ecbcbc37b2c631ee9127f17bfa9/drivers/gpu/drm/xe/xe_pci.c#L167-L350). As of this writing, that includes: Tiger Lake (tgl), Alder Lake-S/P/N (adl_s, adl_p, adl_n), Arc Battlemage (bmg), and the upcoming 16th gen Panther Lake (ptl), among others. Notably, this does not include Lunar Lake (lnl), Meteor Lake (mtl), or Arrow Lake (also detected as mtl and has no distinct firmware). I assume SR-IOV support for those generations will come later, but that will remain to be seen.

# Build Process
The build process is run via this GHA workflow: [./.github/workflows/build.yaml](./.github/workflows/build.yaml)  
The intent is that anyone can fork and build their own copy if so desired with minimal modification.  
The steps largely follow the same process the official kernel is built with, with some exceptions to prevent unnecessarily building and maintaining extra packages unrelated to the kernel.