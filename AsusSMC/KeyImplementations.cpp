//
//  KeyImplementations.cpp
//  AsusSMC
//
//  Copyright © 2018-2020 Le Bao Hiep. All rights reserved.
//

#include "KeyImplementations.hpp"
#include "AsusSMC.hpp"

SMC_RESULT SMCKBrdBLightValue::update(const SMC_DATA *src)  {
    lkb *value = new lkb;
    lilu_os_memcpy(value, src, size);

    // tval is in range [0x0, 0xffb]
    uint16_t tval = (value->val1 << 4) | (value->val2 >> 4);
    DBGLOG("lksb", "LKSB update %d", tval);

    delete value;

    if (asusSMCInstance) {
        asusSMCInstance->message(kSetKeyboardBacklightMessage, nullptr, &tval);
    }

    lilu_os_memcpy(data, src, size);
    return SmcSuccess;
}

SMC_RESULT F0Ac::readAccess() {
    uint16_t speed = atomic_load_explicit(currentSpeed, memory_order_acquire);
    *reinterpret_cast<uint16_t *>(data) = VirtualSMCAPI::encodeIntFp(SmcKeyTypeFpe2, speed);
    return SmcSuccess;
}

SMC_RESULT BDVT::update(const SMC_DATA *src)  {
    bool state = false;
    lilu_os_memcpy(&state, src, size);

    // BDVT is 00 when battery health is enabled and 01 when disabled
    state = !state;

    AsusSMC *drv = OSDynamicCast(AsusSMC, dst);
    drv->toggleBatteryConservativeMode(state);

    lilu_os_memcpy(data, src, size);
    return SmcSuccess;
}
