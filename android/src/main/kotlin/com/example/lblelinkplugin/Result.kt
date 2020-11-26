package com.example.lblelinkplugin

class Result {
    var map: MutableMap<String, Any>? = null

    init {
        map = mutableMapOf();
    }

    fun addParam(name: String, value: Any): Result {
        map?.run {
            put(name, value)
        }
        return this;
    }

    fun getResult():MutableMap<String, Any> = map!!

}
