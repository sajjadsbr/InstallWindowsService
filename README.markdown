# Install Windows Service Task (v1.2.0)

## English

### Overview
This Azure DevOps extension provides a task to install and start NServiceBus-compatible Windows services during deployments. It copies all files from a specified source published path to the installation directory and sets up the service.

### Prerequisites
- Azure DevOps account with pipeline access.
- Published build artifacts containing the service files (including an `.exe` file).
- Windows environment for service installation.

### Usage
1. Add the "Install NServiceBus Windows Service" task to your pipeline.
2. Configure the following inputs:
   - **Service Name**: The name of the Windows service.
   - **Display Name**: The display name of the service in the Services panel.
   - **Source Published Path**: Path to the published build artifacts (e.g., `$(Build.ArtifactStagingDirectory)`).
   - **Install Path**: Destination path where the service files will be installed.
   - **Service Account Type**: Choose `LocalSystem` or `Custom` (with username/password).
   - **Start Type**: Set to `Automatic`, `Manual`, or `Disabled`.
   - **Endpoint Configuration Type** (optional): Specify the NServiceBus endpoint configuration type.
3. Run the pipeline to install and start the service.

### Notes
- Ensure the `Source Published Path` contains at least one `.exe` file for the service.
- Logs are written to `$env:Temp\<ServiceName>-install-log.txt`.

---

## فارسی

### مرور کلی
این افزونه Azure DevOps یک تسک برای نصب و راه‌اندازی سرویس‌های ویندوزی سازگار با NServiceBus در طول فرآیند دیپلوی ارائه می‌دهد. این تسک تمام فایل‌ها را از مسیر پابلیش‌شده مشخص‌شده به دایرکتوری نصب کپی کرده و سرویس را راه‌اندازی می‌کند.

### پیش‌نیازها
- حساب کاربری Azure DevOps با دسترسی به پایپلاین.
- آرتیفکت‌های بیلد پابلیش‌شده که شامل فایل‌های سرویس (از جمله یک فایل `.exe`) باشند.
- محیط ویندوزی برای نصب سرویس.

### نحوه استفاده
1. تسک "Install NServiceBus Windows Service" را به پایپلاین خود اضافه کنید.
2. ورودی‌های زیر را پیکربندی کنید:
   - **نام سرویس**: نام سرویس ویندوزی.
   - **نام نمایشی**: نام نمایشی سرویس در پنل سرویس‌ها.
   - **مسیر پابلیش‌شده منبع**: مسیر آرتیفکت‌های بیلد پابلیش‌شده (مثلاً `$(Build.ArtifactStagingDirectory)`).
   - **مسیر نصب**: مسیر مقصد که فایل‌های سرویس در آن نصب می‌شوند.
   - **نوع حساب سرویس**: گزینه `LocalSystem` یا `Custom` (با نام کاربری و رمز عبور) را انتخاب کنید.
   - **نوع شروع**: گزینه `Automatic`، `Manual` یا `Disabled` را تنظیم کنید.
   - **نوع پیکربندی نقطه پایانی** (اختیاری): نوع پیکربندی نقطه پایانی NServiceBus را مشخص کنید.
3. پایپلاین را اجرا کنید تا سرویس نصب و راه‌اندازی شود.

### نکات
- مطمئن شوید که `مسیر پابلیش‌شده منبع` حداقل شامل یک فایل `.exe` برای سرویس باشد.
- لاگ‌ها در مسیر `$env:Temp\<ServiceName>-install-log.txt` نوشته می‌شوند.