// SPDX-License-Identifier: MIT
// مشخص می‌کند که این کد تحت مجوز MIT منتشر شده است.

pragma solidity ^0.8.23;
// نسخه کامپایلر Solidity مورد استفاده را مشخص می‌کند (نسخه 0.8.23 یا بالاتر).

// قرارداد Voting برای ایجاد و مدیریت پروپوزال‌ها و رای‌گیری‌ها طراحی شده است.
contract Voting {
    // ساختار Proposal برای ذخیره اطلاعات هر پروپوزال استفاده می‌شود.
    struct Proposal {
        string name; // نام پروپوزال
        string description; // توضیحات پروپوزال
        address creator; // آدرس ایجادکننده پروپوزال
        uint createTime; // زمان ایجاد پروپوزال
        uint endTime; // زمان پایان رای‌گیری برای پروپوزال
        uint yesVotes; // تعداد رای‌های موافق
        uint noVotes; // تعداد رای‌های مخالف
        mapping(address => bool) voteCheck; // این مپینگ چک می‌کند که آیا یک آدرس خاص به این پروپوزال رای داده است یا خیر.
    }

    // یک آرایه از پروپوزال‌ها برای ذخیره همه پروپوزال‌ها.
    Proposal[] public proposals;

    // تابع addProposal برای ایجاد یک پروپوزال جدید استفاده می‌شود.
    function addProposal(string memory _name, string memory _description, uint _duration) public {
        // ایجاد یک پروپوزال جدید و ذخیره آن در آرایه proposals.
        Proposal storage proposal = proposals.push();
        proposal.name = _name; // تنظیم نام پروپوزال
        proposal.description = _description; // تنظیم توضیحات پروپوزال
        proposal.creator = msg.sender; // تنظیم آدرس ایجادکننده پروپوزال
        proposal.createTime = block.timestamp; // تنظیم زمان ایجاد پروپوزال (زمان فعلی)
        proposal.endTime = block.timestamp + (_duration * 1 minutes); // تنظیم زمان پایان رای‌گیری (زمان فعلی + مدت زمان مشخص شده)
        proposal.yesVotes = 0; // مقداردهی اولیه رای‌های موافق به صفر
        proposal.noVotes = 0; // مقداردهی اولیه رای‌های مخالف به صفر
    }

    // تابع vote برای ثبت رای به یک پروپوزال خاص استفاده می‌شود.
    function vote(uint index, bool _voteYes) public {
        require(index < proposals.length, "not found...."); // چک می‌کند که پروپوزال با این ایندکس وجود داشته باشد.
        Proposal storage proposal = proposals[index]; // دسترسی به پروپوزال مورد نظر
        require(!proposal.voteCheck[msg.sender], "already voted this proposal"); // چک می‌کند که کاربر قبلاً به این پروپوزال رای نداده باشد.
        require(block.timestamp < proposal.endTime, "timed out"); // چک می‌کند که زمان رای‌گیری به پایان نرسیده باشد.

        // اگر کاربر رای موافق داده باشد:
        if (_voteYes) {
            proposal.yesVotes++; // افزایش تعداد رای‌های موافق
        } else {
            proposal.noVotes++; // افزایش تعداد رای‌های مخالف
        }

        proposal.voteCheck[msg.sender] = true; // علامت‌گذاری که کاربر به این پروپوزال رای داده است.
    }

    // تابع result برای مشاهده نتیجه رای‌گیری یک پروپوزال خاص استفاده می‌شود.
    // function result(uint indexProposal) public view returns (uint yesVote, uint noVote) {
    //     require(indexProposal < proposals.length, "not found"); // چک می‌کند که پروپوزال با این ایندکس وجود داشته باشد.
    //     Proposal storage proposal = proposals[indexProposal]; // دسترسی به پروپوزال مورد نظر
    //     return (proposal.yesVotes, proposal.noVotes); // بازگرداندن تعداد رای‌های موافق و مخالف
    // }
}