NAME := sensor

$(NAME)_MBINS_TYPE := kernel

$(NAME)_SOURCES += \
        hal/sensor_hal.c \
        hal/sensor_drv_api.c 


CONFIG_SENSOR =  $(addsuffix .c,$(CONFIG_SENSOR_DRV_NAME))
SENSOR_ALL_FILE=$(notdir $(wildcard device/sensor/drv/*.c))

FILTER_FILE=$(foreach defines_var,$(1),$(filter $(defines_var),$(2)))
SENSOR_SRC_FILE=$(call FILTER_FILE,$(CONFIG_SENSOR),$(SENSOR_ALL_FILE))

$(NAME)_SOURCES += $(addprefix drv/,$(SENSOR_SRC_FILE)) 

CONFIG_DRV_SET = $(word 1,$(CONFIG_SENSOR_DRV_NAME))

ifneq ($(CONFIG_DRV_SET),)
GLOBAL_DEFINES += SENSOR_DRV_AUTO_INIT
endif

ifeq ($(modbus_sensor_enable),1)
$(NAME)_SOURCES += drv/drv_modbus_sensors.c
$(NAME)_COMPONENTS  += rhino.bus.mbmaster
GLOBAL_DEFINES += UDATA_MODBUS
endif

ifeq (gps.sim868,$(module))
$(NAME)_COMPONENTS += network.sal network.sal.atparser
$(NAME)_COMPONENTS += network.sal.gprs.sim800
$(NAME)_SOURCES += drv/drv_gps_simcom_sim868.c
GLOBAL_DEFINES += AOS_SENSOR_GPS_SIMCON_SIM868
endif

ifeq ($(COMPILER),)
$(NAME)_CFLAGS      += -Wall -Werror
else ifeq ($(COMPILER),gcc)
$(NAME)_CFLAGS      += -Wall -Werror
endif

GLOBAL_INCLUDES +=  ./include
GLOBAL_DEFINES      += AOS_SENSOR


