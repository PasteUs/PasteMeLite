/*
@File: server.go
@Contact: lucien@lucien.ink
@Licence: (C)Copyright 2019 Lucien Shui

@Modify Time      @Author    @Version    @Description
------------      -------    --------    -----------
2019-06-21 08:37  Lucien     1.0         Init
*/
package server

import (
	"fmt"
	"github.com/PasteUs/PasteMeGoBackend/flag"
	"github.com/gin-gonic/gin"
	"github.com/wonderivan/logger"
)

var router *gin.Engine

func init() {
	if !flag.Debug {
		gin.SetMode(gin.ReleaseMode)
	}
	router = gin.Default()

	api := router.Group("/api")
	{
		api.GET("/", beat)
		api.GET("/:token", query)
		api.POST("/", permanentCreator)
		api.POST("/once", readOnceCreator)
		api.PUT("/:key", temporaryCreator)
		// router.NoRoute(notFoundHandler)
	}

	router.Static("/pasteme_frontend/", "pasteme_frontend/")
	router.Static("/usr/", "pasteme_frontend/usr/")

	router.NoRoute(func(requests *gin.Context) {
		requests.File("pasteme_frontend/index.html")
	})
}

func Run(address string, port uint16) {
	if err := router.Run(fmt.Sprintf("%s:%d", address, port)); err != nil {
		logger.Painc("Run server failed: " + err.Error())
	}
}
