// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import {application} from "./application"

import AppointmentController from "./appointment_controller";
import CountDownController from "./countdown_controller";

application.register("appointment", AppointmentController)
application.register("countdown", CountDownController)
