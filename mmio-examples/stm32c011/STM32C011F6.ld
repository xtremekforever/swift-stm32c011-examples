ENTRY(reset)

MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 32K
  RAM (xrw)  : ORIGIN = 0x20000000, LENGTH = 6K
}

SECTIONS
{
  .vectors :
  {
    KEEP(*(__VECTORS*))
  } > FLASH

  .text : ALIGN(16) {
    _stext = .;
    *(.text*)
    _etext = .;
  } > FLASH
}
