// SPDX-License-Identifier: MIT
// مشخص می‌کند که این کد تحت مجوز MIT منتشر شده است.

pragma solidity ^0.8.6;
// نسخه کامپایلر Solidity مورد استفاده را مشخص می‌کند (نسخه 0.8.6 یا بالاتر).

// قرارداد Voting برای ایجاد یک سیستم رای‌گیری ساده طراحی شده است.
contract Voting {
    // ساختار Detailed برای ذخیره اطلاعات هر رای‌دهنده و تعداد رای‌هایش استفاده می‌شود.
    struct Detailed {
        uint id; // شناسه منحصر به فرد رای‌دهنده
        string name; // نام رای‌دهنده
        uint vote; // تعداد رای‌های داده شده توسط این کاربر (در این کد استفاده نشده است)
        uint voteCount; // تعداد کل رای‌های دریافتی برای این کاربر
        uint count; // شمارنده کلی (در این کد استفاده نشده است)
        address owner; // آدرس ایجادکننده این رای‌دهنده
    }

    // یک مپینگ برای ذخیره اطلاعات هر رای‌دهنده بر اساس شناسه (id).
    mapping(uint => Detailed) public Detailes;

    // یک مپینگ برای چک کردن اینکه آیا یک آدرس خاص قبلاً رای داده است یا خیر.
    mapping(address => bool) public userCheckVote;

    // آدرس مالک قرارداد (فردی که قرارداد را deploy کرده است).
    address public owner;

    // شمارنده کلی برای تعداد رای‌دهندگان ثبت‌شده.
    uint public count;

    // سازنده (constructor) قرارداد که هنگام deploy شدن قرارداد اجرا می‌شود.
    constructor()  {
        owner = msg.sender; // آدرس deploy کننده قرارداد را به عنوان مالک تنظیم می‌کند.
    }

    // تابع addUserVote برای اضافه کردن یک رای‌دهنده جدید استفاده می‌شود.
    function addUserVote(string memory name) public returns (string memory) {
        require(msg.sender == owner, "You are not the owner."); // فقط مالک قرارداد می‌تواند رای‌دهنده اضافه کند.
        count++; // شمارنده رای‌دهندگان را افزایش می‌دهد.
        Detailes[count] = Detailed(count, name, 0, 0, count, msg.sender); // اطلاعات رای‌دهنده جدید را ذخیره می‌کند.
        return "success"; // پیام موفقیت‌آمیز بودن عملیات را بازمی‌گرداند.
    }

    // تابع vote برای ثبت رای به یک رای‌دهنده خاص استفاده می‌شود.
    function vote(uint id) public returns (string memory) {
        require(id <= count && id > 0, "Not found."); // چک می‌کند که رای‌دهنده با این شناسه وجود داشته باشد.
        require(!userCheckVote[msg.sender], "You have already voted."); // چک می‌کند که کاربر قبلاً رای نداده باشد.
        Detailes[id].voteCount++; // تعداد رای‌های رای‌دهنده مورد نظر را افزایش می‌دهد.
        userCheckVote[msg.sender] = true; // علامت می‌زند که این کاربر رای داده است.
        return "success"; // پیام موفقیت‌آمیز بودن عملیات را بازمی‌گرداند.
    }

    // تابع showVote برای پیدا کردن رای‌دهنده برنده (کسی که بیشترین رای را دارد) استفاده می‌شود.
    function showVote() public view returns (string memory) {
        uint winnerId = 0; // شناسه رای‌دهنده برنده
        uint winerVote = 0; // بیشترین تعداد رای‌های دریافتی

        // حلقه برای بررسی همه رای‌دهندگان و پیدا کردن برنده
        for (uint i = 1; i <= count; i++) {
            if (Detailes[i].voteCount >= winerVote) { // اگر رای‌های این رای‌دهنده بیشتر از رکورد فعلی باشد:
                winnerId = i; // شناسه رای‌دهنده برنده را به‌روز می‌کند.
                winerVote = Detailes[i].voteCount; // رکورد بیشترین رای‌ها را به‌روز می‌کند.
            }
        }

        // نام رای‌دهنده برنده را بازمی‌گرداند.
        return Detailes[winnerId].name;
    }
}