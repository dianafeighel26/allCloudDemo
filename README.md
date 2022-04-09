# allCloudDemo

Code to run in anonymous window to schedule the batch class to run every hour:

    HourlyScheduleToUpdateAccountWeather sc = new HourlyScheduleToUpdateAccountWeather();
    String cronExp = '0 0 * * * ?';
    String jobID = System.schedule('Update Account', cronExp, sc);
