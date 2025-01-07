abstract class Room {
    constructor(
      public roomId: number,
      public type: string,
      public pricePerNight: number,
      public isAvailable: boolean = true
    ) {}
  
    bookRoom(): void {
      if (!this.isAvailable) {
        console.error(`Phòng ${this.roomId} đã được đặt.`);
        return;
      }
      this.isAvailable = false;
      console.log(`Phòng ${this.roomId} đã được đặt.`);
    }
  
    releaseRoom(): void {
      this.isAvailable = true;
      console.log(`Phòng ${this.roomId} đã được trả.`);
    }
  
    abstract calculateCost(nights: number): number;
    abstract getAdditionalServices(): string[];
    abstract applyDiscount(discountRate: number): number;
    abstract getCancellationPolicy(): string;
  }
  
  class StandardRoom extends Room {
    calculateCost(nights: number): number {
      return this.pricePerNight * nights;
    }
  
    getAdditionalServices(): string[] {
      return [];
    }
  
    applyDiscount(discountRate: number): number {
      return this.pricePerNight * (1 - discountRate);
    }
  
    getCancellationPolicy(): string {
      return "Hoàn lại 100% nếu hủy trước 1 ngày.";
    }
  }
  
  class DeluxeRoom extends Room {
    calculateCost(nights: number): number {
      return this.pricePerNight * nights;
    }
  
    getAdditionalServices(): string[] {
      return ["Bữa sáng miễn phí"];
    }
  
    applyDiscount(discountRate: number): number {
      return this.pricePerNight * (1 - discountRate);
    }
  
    getCancellationPolicy(): string {
      return "Hoàn lại 50% nếu hủy trước 2 ngày.";
    }
  }
  
  class SuiteRoom extends Room {
    calculateCost(nights: number): number {
      return this.pricePerNight * nights;
    }
  
    getAdditionalServices(): string[] {
      return ["Dịch vụ spa", "Minibar"];
    }
  
    applyDiscount(discountRate: number): number {
      return this.pricePerNight * (1 - discountRate);
    }
  
    getCancellationPolicy(): string {
      return "Không hoàn lại tiền nếu hủy.";
    }
  }
  
  class Person {
    constructor(
      public id: number,
      public name: string,
      public email: string,
      public phone: string
    ) {}
  
    getDetails(): string {
      return `ID: ${this.id}, Name: ${this.name}, Email: ${this.email}, Phone: ${this.phone}`;
    }
  }
  
  class Booking {
    public totalCost: number;
  
    constructor(
      public bookingId: number,
      public customer: Person,
      public room: Room,
      public nights: number
    ) {
      this.totalCost = this.room.calculateCost(this.nights);
    }
  
    getDetails(): string {
      return `Booking ID: ${this.bookingId}, Customer: ${this.customer.name}, Room: ${this.room.type}, Nights: ${this.nights}, Total Cost: ${this.totalCost}`;
    }
  }
  
  class HotelManager {
    private rooms: Room[] = [];
    private bookings: Booking[] = [];
    private customers: Person[] = [];
    private roomIdCounter = 1;
    private bookingIdCounter = 1;
    private customerIdCounter = 1;
  
    addRoom(type: string, pricePerNight: number): void {
      let room: Room;
      switch (type) {
        case "Standard":
          room = new StandardRoom(this.roomIdCounter++, type, pricePerNight);
          break;
        case "Deluxe":
          room = new DeluxeRoom(this.roomIdCounter++, type, pricePerNight);
          break;
        case "Suite":
          room = new SuiteRoom(this.roomIdCounter++, type, pricePerNight);
          break;
        default:
          console.error("Loại phòng không hợp lệ.");
          return;
      }
      this.rooms.push(room);
      console.log(`Thêm phòng ${type} với giá ${pricePerNight}/đêm.`);
    }
  
    addCustomer(name: string, email: string, phone: string): Person {
      const customer = new Person(this.customerIdCounter++, name, email, phone);
      this.customers.push(customer);
      console.log(`Thêm khách hàng: ${name}`);
      return customer;
    }
  
    bookRoom(customerId: number, roomId: number, nights: number): Booking | void {
      const customer = this.customers.find((c) => c.id === customerId);
      const room = this.rooms.find((r) => r.roomId === roomId);
  
      if (!customer) {
        console.error("Khách hàng không tồn tại.");
        return;
      }
      if (!room || !room.isAvailable) {
        console.error("Phòng không tồn tại hoặc đã được đặt.");
        return;
      }
  
      room.bookRoom();
      const booking = new Booking(this.bookingIdCounter++, customer, room, nights);
      this.bookings.push(booking);
      console.log("Đặt phòng thành công:", booking.getDetails());
      return booking;
    }
  
    releaseRoom(roomId: number): void {
      const room = this.rooms.find((r) => r.roomId === roomId);
      if (room) {
        room.releaseRoom();
      } else {
        console.error("Phòng không tồn tại.");
      }
    }
  
    listAvailableRooms(): void {
      const availableRooms = this.rooms.filter((r) => r.isAvailable);
      console.log("Danh sách phòng trống:");
      availableRooms.forEach((room) => console.log(room));
    }
  
    listBookingsByCustomer(customerId: number): void {
      const customerBookings = this.bookings.filter(
        (b) => b.customer.id === customerId
      );
      console.log(`Danh sách đặt phòng của khách hàng ID ${customerId}:`);
      customerBookings.forEach((booking) => console.log(booking.getDetails()));
    }
  
    calculateTotalRevenue(): number {
      return this.bookings.reduce((total, booking) => total + booking.totalCost, 0);
    }
  
    getRoomTypesCount(): void {
      const roomTypeCount = this.rooms.reduce((acc, room) => {
        acc[room.type] = (acc[room.type] || 0) + 1;
        return acc;
      }, {} as Record<string, number>);
      console.log("Số lượng từng loại phòng:", roomTypeCount);
    }
  
    applyDiscountToRoom(roomId: number, discountRate: number): void {
      const room = this.rooms.find((r) => r.roomId === roomId);
      if (room) {
        const newPrice = room.applyDiscount(discountRate);
        console.log(`Giá mới của phòng ${roomId}: ${newPrice}`);
      } else {
        console.error("Phòng không tồn tại.");
      }
    }
  
    getRoomServices(roomId: number): void {
      const room = this.rooms.find((r) => r.roomId === roomId);
      if (room) {
        console.log(`Dịch vụ bổ sung của phòng ${roomId}:`, room.getAdditionalServices());
      } else {
        console.error("Phòng không tồn tại.");
      }
    }
  
    getCancellationPolicy(roomId: number): void {
      const room = this.rooms.find((r) => r.roomId === roomId);
      if (room) {
        console.log(`Chính sách hủy phòng ${roomId}:`, room.getCancellationPolicy());
      } else {
        console.error("Phòng không tồn tại.");
      }
    }
  }
  

  const hotelManager = new HotelManager();
  
  function runHotelManagement() {
    let running = true;
  
    while (running) {
      console.log(`
        1. Thêm khách hàng
        2. Thêm phòng
        3. Đặt phòng
        4. Trả phòng
        5. Hiển thị danh sách phòng còn trống
        6. Hiển thị danh sách đặt phòng của khách hàng
        7. Tính tổng doanh thu
        8. Đếm số lượng từng loại phòng
        9. Áp dụng giảm giá cho phòng
        10. Hiển thị dịch vụ bổ sung của phòng
        11. Hiển thị chính sách hủy phòng
        12. Thoát chương trình
      `);
  
      const choice = prompt("Nhập lựa chọn: ");
  
      switch (choice) {
        case "1":
          const name = prompt("Nhập tên khách hàng: ");
          const email = prompt("Nhập email khách hàng: ");
          const phone = prompt("Nhập số điện thoại khách hàng: ");
          hotelManager.addCustomer(name || "", email || "", phone || "");
          break;
        case "2":
            const type = prompt("Nhập loại phòng (Standard, Deluxe, Suite): ");
            const pricePerNight = parseFloat(prompt("Nhập giá phòng mỗi đêm: ") || "0");
            if (type && !isNaN(pricePerNight) && pricePerNight > 0) {
                hotelManager.addRoom(type, pricePerNight);
            } else {
            console.error("Dữ liệu không hợp lệ. Vui lòng thử lại.");
            }
        break;

      case "3":
        const customerId = parseInt(prompt("Nhập ID khách hàng: ") || "0");
        const roomId = parseInt(prompt("Nhập ID phòng: ") || "0");
        const nights = parseInt(prompt("Nhập số đêm: ") || "0");
        if (!isNaN(customerId) && !isNaN(roomId) && !isNaN(nights) && nights > 0) {
          hotelManager.bookRoom(customerId, roomId, nights);
        } else {
          console.error("Thông tin đặt phòng không hợp lệ.");
        }
        break;

      case "4":
        const releaseRoomId = parseInt(prompt("Nhập ID phòng cần trả: ") || "0");
        if (!isNaN(releaseRoomId)) {
          hotelManager.releaseRoom(releaseRoomId);
        } else {
          console.error("ID phòng không hợp lệ.");
        }
        break;

      case "5":
        hotelManager.listAvailableRooms();
        break;

      case "6":
        const bookingCustomerId = parseInt(prompt("Nhập ID khách hàng: ") || "0");
        if (!isNaN(bookingCustomerId)) {
          hotelManager.listBookingsByCustomer(bookingCustomerId);
        } else {
          console.error("ID khách hàng không hợp lệ.");
        }
        break;

      case "7":
        const totalRevenue = hotelManager.calculateTotalRevenue();
        console.log(`Tổng doanh thu từ các đặt phòng: ${totalRevenue}`);
        break;

      case "8":
        hotelManager.getRoomTypesCount();
        break;

      case "9":
        const discountRoomId = parseInt(prompt("Nhập ID phòng cần áp dụng giảm giá: ") || "0");
        const discountRate = parseFloat(prompt("Nhập tỷ lệ giảm giá (ví dụ: 0.1 cho 10%): ") || "0");
        if (!isNaN(discountRoomId) && !isNaN(discountRate) && discountRate > 0 && discountRate <= 1) {
          hotelManager.applyDiscountToRoom(discountRoomId, discountRate);
        } else {
          console.error("Thông tin giảm giá không hợp lệ.");
        }
        break;

      case "10":
        const serviceRoomId = parseInt(prompt("Nhập ID phòng để xem dịch vụ bổ sung: ") || "0");
        if (!isNaN(serviceRoomId)) {
          hotelManager.getRoomServices(serviceRoomId);
        } else {
          console.error("ID phòng không hợp lệ.");
        }
        break;

      case "11":
        const policyRoomId = parseInt(prompt("Nhập ID phòng để xem chính sách hủy: ") || "0");
        if (!isNaN(policyRoomId)) {
          hotelManager.getCancellationPolicy(policyRoomId);
        } else {
          console.error("ID phòng không hợp lệ.");
        }
        break;

      case "12":
        running = false;
        console.log("Thoát chương trình. Hẹn gặp lại!");
        break;

      default:
        console.error("Lựa chọn không hợp lệ. Vui lòng thử lại.");
        break;
    }
  }
}


runHotelManagement();








  