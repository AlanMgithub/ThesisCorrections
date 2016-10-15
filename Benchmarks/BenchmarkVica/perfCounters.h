
unsigned long read_miss_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $2" : "=r"(retval));
  return retval;
}

unsigned long read_hit_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $3" : "=r"(retval));
  return retval;
}

unsigned long read_ll_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $4" : "=r"(retval));
  return retval;
}

unsigned long read_sc_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $5" : "=r"(retval));
  return retval;
}

unsigned long read_inv_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $6" : "=r"(retval));
  return retval;
}

unsigned long read_invHit_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $7" : "=r"(retval));
  return retval;
}

unsigned long read_valid_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $7" : "=r"(retval));
  return retval;
}

unsigned long read_sync_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $4" : "=r"(retval));
  return retval;
}

unsigned long read_init_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $5" : "=r"(retval));
  return retval;
}

unsigned long read_timeMiss_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $6" : "=r"(retval));
  return retval;
}

unsigned long read_timeHit_counter()
{
  unsigned long retval;
  asm volatile("rdhwr %0, $7" : "=r"(retval));
  return retval;
}


